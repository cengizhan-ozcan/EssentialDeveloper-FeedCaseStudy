//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by Cengizhan Özcan on 4.02.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation
import EssentialFeed

public protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

public final class FeedPresenter {
    
    private let feedView: FeedView
    private let loadingView: ResourceLoadingView
    private let errorView: ResourceErrorView
    
    public init(feedView: FeedView, loadingView: ResourceLoadingView, errorView: ResourceErrorView) {
        self.feedView = feedView
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    public static var title: String {
        return NSLocalizedString("FEED_VIEW_TITLE", tableName: "Feed", bundle: Bundle(for: FeedPresenter.self),
                                 comment: "Title for the feed view")
    }
    
    private var feedLoadError: String {
        return NSLocalizedString("GENERIC_CONNECTION_ERROR", tableName: "Shared", bundle: Bundle(for: FeedPresenter.self),
                                 comment: "Error message displayed when we can't load the image feed from the server")
    }
    
    public func didStartLoadingFeed() {
        errorView.display(.noError)
        loadingView.display(ResouceLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(ResouceLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoadingFeed(with error: Error) {
        errorView.display(.error(message: feedLoadError))
        loadingView.display(ResouceLoadingViewModel(isLoading: false))
    }
}
