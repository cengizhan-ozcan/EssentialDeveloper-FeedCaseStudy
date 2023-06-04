//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Cengizhan Özcan on 22.01.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import UIKit
import EssentialFeed
import EssentialFeediOS
import EssentialFeedPresentation
import SharedPresentation
import SharedAPI

public final class FeedUIComposer {
    
    private init() {}
    
    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> ListViewController {
        let presentationAdapter = LoadResourcePresentationAdapter<ResourceLoaderAdapter, [FeedImage], FeedViewAdapter>(loader: ResourceLoaderAdapter(loader: MainQueueDispatchDecorator(decoratee: feedLoader)))
        
        let feedController = makeFeedViewController(title: FeedPresenter.title)
        feedController.onRefresh = presentationAdapter.loadResource
        presentationAdapter.presenter = LoadResourcePresenter(resourceView: FeedViewAdapter(controller: feedController,
                                                                                            imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader)),
                                                              loadingView: WeakRefVirtualProxy(feedController),
                                                              errorView: WeakRefVirtualProxy(feedController),
                                                              mapper: FeedPresenter.map)
        return feedController
    }
    
    private static func makeFeedViewController(title: String) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! ListViewController
        feedController.title = FeedPresenter.title
        return feedController
    }
}


private class ResourceLoaderAdapter: ResourceLoader {
    
    let loader: FeedLoader
    
    init(loader: FeedLoader) {
        self.loader = loader
    }
    
    func load(completion: @escaping (Result<[FeedImage], Error>) -> Void) -> ResourceLoaderTask? {
        loader.load(completion: completion)
        return nil
    }
}
