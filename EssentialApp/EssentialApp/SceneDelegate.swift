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
                                                                                            feedLoader: makeRemoteFeedLoaderWithLocalFallback(),
                                                                                            imageLoader: makeLocalImageLoaderWithRemoteFallback(),
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
        let url = baseURL.appending(path: "/v1/image/\(image.id)/comments")
        let remoteClient = makeRemoteClient()
        let remoteImageCommentLoader = RemoteLoader(url: url, client: remoteClient, mapper: ImageCommentsMapper.map)
        let comments = CommentsUIComposer.commentsComposedWith(commentsLoader: remoteImageCommentLoader)
        navigationController.pushViewController(comments, animated: true)
    }

    func configureWindow() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func makeRemoteClient() -> HTTPClient {
        return httpClient
    }
    
    private func makeRemoteFeedLoaderWithLocalFallback() -> FeedLoader {
        let remoteURL = baseURL.appending(path: "/v1/feed")
        let remoteFeedLoader = RemoteLoader(url: remoteURL, client: makeRemoteClient(), mapper: FeedItemsMapper.map)
        return FeedLoaderWithFallbackComposite(primary: FeedLoaderCacheDecorator(decoratee: remoteFeedLoader, cache: localFeedLoader),
                                               fallback: localFeedLoader)
    }
    
    private func makeLocalImageLoaderWithRemoteFallback() -> FeedImageDataLoader {
        let remoteImageLoader = RemoteFeedImageDataLoaderAdapter(client: makeRemoteClient())
        let localImageLoader = LocalFeedImageDataLoader(store: store)
        return FeedImageDataLoaderWithFallbackComposite(primary: localImageLoader,
                                                        fallback: FeedImageDataCacheDecorator(decoratee: remoteImageLoader, cache: localImageLoader))
    }
}

extension RemoteLoader: FeedLoader where Resource == [FeedImage] {}
extension RemoteLoader: ImageCommentLoader where Resource == [ImageComment] {}

