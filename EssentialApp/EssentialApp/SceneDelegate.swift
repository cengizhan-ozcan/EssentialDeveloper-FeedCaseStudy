//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Cengizhan Özcan on 26.02.2023.
//

import os
import UIKit
import CoreData
import EssentialFeed
import EssentialFeedAPI
import EssentialFeedCache
import EssentialFeediOS
import EssentialFeedAPIInfrastructure
import EssentialFeedCacheInfrastructure
import EssentialImageCommentsAPI
import SharedAPI
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    let localStoreURL = NSPersistentContainer.defaultDirectoryURL().appending(component: "feed-store.sqlite")
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var logger = Logger(subsystem: "com.cengizhanozcan.EssentialApp", category: "main")
    
    private lazy var store: FeedStore & FeedImageDataStore = {
        do {
            return try CoreDataFeedStore(storeURL: localStoreURL)
        } catch {
            assertionFailure("Failed to instantiate CoreData store with error: \(error.localizedDescription)")
            logger.fault("Failed to instantiate CoreData store with error: \(error.localizedDescription)")
            return NullStore()
        }
    }()
    
    private lazy var localFeedLoader = {
        LocalFeedLoader(store: store, currentDate: Date.init)
    }()
    
    private lazy var baseURL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed")!
    
    private lazy var navigationController = UINavigationController(rootViewController: FeedUIComposer.feedComposedWith(
        feedLoader: makeRemoteFeedLoaderWithLocalFallback,
        imageLoader: makeLocalImageLoaderWithRemoteFallback,
        selection: showComments(for:)))
    
    convenience init(httpClient: HTTPClient, store: FeedStore & FeedImageDataStore) {
        self.init()
        self.httpClient = httpClient
        self.store = store
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        localFeedLoader.validateCache { _ in }
    }
    
    private func showComments(for image: FeedImage) {
        let commentsLoader = makeRemoteImageCommentLoader(with: image)
        let comments = CommentsUIComposer.commentsComposedWith(commentsLoader: commentsLoader)
        navigationController.pushViewController(comments, animated: true)
    }
    
    private func makeRemoteImageCommentLoader(with image: FeedImage) -> () -> AnyPublisher<[ImageComment], Error> {
        let url = ImageCommentsEndpoint.get(image.id).url(baseURL: baseURL)
        return {
            return self.makeRemoteClient()
                .getPublisher(from: url)
                .tryMap(ImageCommentsMapper.map)
                .eraseToAnyPublisher()
        }
    }
    
    func configureWindow() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func makeRemoteClient() -> HTTPClient {
        return httpClient
    }
    
    private func makeRemoteFeedLoaderWithLocalFallback() -> AnyPublisher<Paginated<FeedImage>, Error> {
        makeRemoteFeedLoader()
            .caching(to: localFeedLoader)
            .fallback(to: localFeedLoader.loadPublisher)
            .map(makeFirstPage(items:))
            .eraseToAnyPublisher()
    }
    
    private func makeRemoteLoadMoreLoader(last: FeedImage?) -> AnyPublisher<Paginated<FeedImage>, Error> {
        localFeedLoader.loadPublisher()
            .zip(makeRemoteFeedLoader(after: last))
            .map { (cachedItems, newItems) in
                (cachedItems + newItems, newItems.last)
            }
            .map(makePage)
            .caching(to: localFeedLoader)
            .eraseToAnyPublisher()
    }
    
    private func makeRemoteFeedLoader(after: FeedImage? = nil) -> AnyPublisher<[FeedImage], Error> {
        let url = FeedEndpoint.get(after: after).url(baseURL: baseURL)
        
        return makeRemoteClient()
            .getPublisher(from: url)
            .tryMap(FeedItemsMapper.map)
            .eraseToAnyPublisher()
    }
    
    private func makeFirstPage(items: [FeedImage]) -> Paginated<FeedImage> {
        makePage(items: items, last: items.last)
    }
    
    private func makePage(items: [FeedImage], last: FeedImage?) -> Paginated<FeedImage> {
        Paginated(items: items, loadMorePublisher: last.map { last in
            { self.makeRemoteLoadMoreLoader(last: last) }
        })
    }
    
    private func makeLocalImageLoaderWithRemoteFallback(url: URL) -> FeedImageDataLoader.Publisher {
        //let client = HTTPClientProfilingDecorator(decoratee: makeRemoteClient(), logger: logger)
        let client = makeRemoteClient()
        let localImageLoader = LocalFeedImageDataLoader(store: store)
        return localImageLoader.loadImageDataPublisher(from: url)
            .fallback(to: { [logger] in
                client
                    .getPublisher(from: url)
                    .logElapsedTime(url: url, logger: logger)
                    .logErrors(url: url, logger: logger)
                    .tryMap(FeedImageDataMapper.map)
                    .caching(to: localImageLoader, using: url)
            })
    }
}

// Check 78780a0ad3b05390c469cd684884347200880f13 commit for project without using combine. After this commit all classes will be adapted to Combine.

extension Publisher {
    
    func logErrors(url: URL, logger: Logger) -> AnyPublisher<Output, Failure> {
        return handleEvents(receiveCompletion: { result in
            if case let .failure(error) = result {
                logger.trace("Failed to load url: \(url) with error: \(error.localizedDescription)")
            }
        }).eraseToAnyPublisher()
    }
    
    func logElapsedTime(url: URL, logger: Logger) -> AnyPublisher<Output, Failure> {
        var startTime = CACurrentMediaTime()
        return handleEvents(receiveSubscription: {  _ in
            logger.trace("Started loading url: \(url)")
            startTime = CACurrentMediaTime()
        }, receiveCompletion: { result in
            let elapsed = CACurrentMediaTime() - startTime
            logger.trace("Finished loading url: \(url) in \(elapsed) seconds")
        }).eraseToAnyPublisher()
    }
}


private class HTTPClientProfilingDecorator: HTTPClient {
    
    private let decoratee: HTTPClient
    private let logger: Logger
    
    internal init(decoratee: HTTPClient, logger: Logger) {
        self.decoratee = decoratee
        self.logger = logger
    }
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        logger.trace("Started loading url: \(url)")
        
        let startTime = CACurrentMediaTime()
        return decoratee.get(from: url) { [logger] result in
            if case let .failure(error) = result {
                logger.trace("Failed to load url: \(url) with error: \(error.localizedDescription)")
            }
            
            let elapsed = CACurrentMediaTime() - startTime
            logger.trace("Finished loading url: \(url) in \(elapsed) seconds")
            
            completion(result)
        }
    }
}
