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
import Combine

public final class FeedUIComposer {
    
    private typealias FeedPrensentationAdapter = LoadResourcePresentationAdapter<Paginated<FeedImage>, FeedViewAdapter>
    
    private init() {}
    
    public static func feedComposedWith(feedLoader: @escaping () -> AnyPublisher<Paginated<FeedImage>, Error>,
                                        imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher,
                                        selection: @escaping (FeedImage) -> Void = { _ in }) -> ListViewController {
        let presentationAdapter = FeedPrensentationAdapter(loader: { feedLoader().dispatchOnMainQueue() })
        
        let feedController = makeFeedViewController(title: FeedPresenter.title)
        feedController.onRefresh = presentationAdapter.loadResource
        presentationAdapter.presenter = LoadResourcePresenter(resourceView: FeedViewAdapter(controller: feedController,
                                                                                            imageLoader: { imageLoader($0).dispatchOnMainQueue() },
                                                                                            selection: selection),
                                                              loadingView: WeakRefVirtualProxy(feedController),
                                                              errorView: WeakRefVirtualProxy(feedController),
                                                              mapper: { $0 })
        return feedController
    }
    
    private static func makeFeedViewController(title: String) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! ListViewController
        feedController.title = title
        return feedController
    }
}
