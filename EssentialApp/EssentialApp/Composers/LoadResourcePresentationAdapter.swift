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

public protocol ResourceLoaderTask {
    func cancel()
}

protocol ResourceLoader {
    
    associatedtype Resource
    
    typealias Result = Swift.Result<Resource, Error>
    
    func load(completion: @escaping (Result) -> Void) -> ResourceLoaderTask?
}

final class LoadResourcePresentationAdapter<Loader: ResourceLoader, Resource, View: ResourceView> where Loader.Resource == Resource {
    
    private let loader: Loader
    private var task: ResourceLoaderTask?
    var presenter: LoadResourcePresenter<Resource, View>?
    
    init(loader: Loader) {
        self.loader = loader
    }
    
    func loadResource() {
        presenter?.didStartLoading()
        task = loader.load { [weak self] result in
            switch result {
            case let .success(resource):
                self?.presenter?.didFinishLoading(with: resource)
            case let .failure(error):
                self?.presenter?.didFinishLoading(with: error)
            }
        }
    }
}

extension LoadResourcePresentationAdapter: FeedViewControllerDelegate where Resource == [FeedImage] {
    
    func didRequestFeedRefresh() {
        loadResource()
    }
}

extension LoadResourcePresentationAdapter: FeedImageCellControllerDelegate where Resource == Data {
    
    func didRequestImage() {
        loadResource()
    }
    
    func didCancelImageRequest() {
        task?.cancel()
        task = nil
    }
}
