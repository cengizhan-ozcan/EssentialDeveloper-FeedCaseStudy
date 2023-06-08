//
//  FeedViewAdapter.swift
//  EssentialFeediOS
//
//  Created by Cengizhan Özcan on 2.02.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import UIKit
import EssentialFeed
import EssentialFeediOS
import EssentialFeedPresentation
import SharedPresentation

final class FeedViewAdapter: ResourceView {
    
    private weak var controller: ListViewController?
    private let imageLoader: FeedImageDataLoader
    private let selection: (FeedImage) -> Void
    
    init(controller: ListViewController, imageLoader: FeedImageDataLoader,
         selection: @escaping (FeedImage) -> Void = { _ in }) {
        self.controller = controller
        self.imageLoader = imageLoader
        self.selection = selection
    }
    
    func display(_ viewModel: FeedViewModel) {
        controller?.display(viewModel.feed.map { model in
            
            let adapter = LoadResourcePresentationAdapter<ResourceLoaderAdapter, Data, WeakRefVirtualProxy<FeedImageCellController>>(loader: ResourceLoaderAdapter(url: model.url, imageLoader: imageLoader))
            
            let view = FeedImageCellController(viewModel: FeedImagePresenter.map(model), delegate: adapter) { [selection] in
                selection(model)
            }
            
            adapter.presenter = LoadResourcePresenter(resourceView: WeakRefVirtualProxy(view),
                                                      loadingView: WeakRefVirtualProxy(view),
                                                      errorView: WeakRefVirtualProxy(view),
                                                      mapper: { data in
                guard let image = UIImage(data: data) else {
                    throw InvalidImageData()
                }
                return image
            })
            return CellController(id: model, view)
        })
    }
}

private struct InvalidImageData: Error {}

private class ResourceLoaderAdapter: ResourceLoader {
    
    private class ResourceLoaderLoaderTask: LoaderTask {
        
        var task: LoaderTask?
        
        init(task: LoaderTask?) {
            self.task = task
        }
        
        func cancel() {
            task?.cancel()
            task = nil
        }
    }
    
    private let url: URL
    private let imageLoader: FeedImageDataLoader
    
    init(url: URL, imageLoader: FeedImageDataLoader) {
        self.url = url
        self.imageLoader = imageLoader
    }
    
    func load(completion: @escaping (Result<Data, Error>) -> Void) -> LoaderTask? {
        let task = imageLoader.loadImageData(from: url, completion: completion)
        return ResourceLoaderLoaderTask(task: task)
    }
}
