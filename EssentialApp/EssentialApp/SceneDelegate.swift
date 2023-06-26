//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Cengizhan Özcan on 26.02.2023.
//

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
    
    private lazy var store: FeedStore & FeedImageDataStore = {
        try! CoreDataFeedStore(storeURL: localStoreURL)
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
        let url = FeedEndpoint.get.url(baseURL: baseURL)
        return makeRemoteClient()
            .getPublisher(from: url)
            .tryMap(FeedItemsMapper.map)
            .caching(to: localFeedLoader)
            .fallback(to: localFeedLoader.loadPublisher)
            .map{
                Paginated(items: $0)
            }
            .eraseToAnyPublisher()
    }
    
    private func makeLocalImageLoaderWithRemoteFallback(url: URL) -> FeedImageDataLoader.Publisher {
        let localImageLoader = LocalFeedImageDataLoader(store: store)
        return localImageLoader.loadImageDataPublisher(from: url)
            .fallback(to: { [weak self] in
                self?.makeRemoteClient()
                    .getPublisher(from: url)
                    .tryMap(FeedImageDataMapper.map)
                    .caching(to: localImageLoader, using: url) ?? Empty().eraseToAnyPublisher()
            })
    }
}

// Check 78780a0ad3b05390c469cd684884347200880f13 commit for project without using combine. After this commit all classes will be adapted to Combine.





