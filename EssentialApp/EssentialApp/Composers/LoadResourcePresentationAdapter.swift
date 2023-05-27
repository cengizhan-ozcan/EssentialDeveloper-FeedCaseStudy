//
//  LoadResourcePresentationAdapter.swift
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
import SharedAPI

final class LoadResourcePresentationAdapter<T, Resource, View: ResourceView> {
    
    private let loader: T
    var presenter: LoadResourcePresenter<Resource, View>?
    
    init(loader: T) {
        self.loader = loader
    }
    
    func startLoading() {
        presenter?.didStartLoading()
    }
    
    func loadResource(with result: Result<Resource, Error>) {
        switch result {
        case let .success(resource):
            presenter?.didFinishLoading(with: resource)
        case let .failure(error):
            presenter?.didFinishLoading(with: error)
        }
    }
}

extension LoadResourcePresentationAdapter: FeedViewControllerDelegate where T == FeedLoader, Resource == [FeedImage] {
    
    func didRequestFeedRefresh() {
        startLoading()
        loader.load { [weak self] result in
            self?.loadResource(with: result)
        }
    }
}
