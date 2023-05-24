//
//  FeedLoaderPresentationAdapter.swift
//  EssentialFeediOS
//
//  Created by Cengizhan Özcan on 2.02.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation
import EssentialFeed
import EssentialFeediOS
import EssentialFeedPresentation
import SharedPresentation

final class FeedLoaderPresentationAdapter: FeedViewControllerDelegate {
    
    private let feedLoader: FeedLoader
    var presenter: LoadResourcePresenter<[FeedImage], FeedViewAdapter>?
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    func didRequestFeedRefresh() {
        presenter?.didStartLoading()
        
        feedLoader.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.presenter?.didFinishLoading(with: feed)
            case let .failure(error):
                self?.presenter?.didFinishLoading(with: error)
            }
        }
    }
}
