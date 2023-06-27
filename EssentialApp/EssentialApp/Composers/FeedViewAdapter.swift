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
import SharedAPI

final class FeedViewAdapter: ResourceView {
    
    private weak var controller: ListViewController?
    private let imageLoader: (URL) -> FeedImageDataLoader.Publisher
    private let selection: (FeedImage) -> Void
    
    private typealias ImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, WeakRefVirtualProxy<FeedImageCellController>>
    private typealias LoadMorePresentationAdapter = LoadResourcePresentationAdapter<Paginated<FeedImage>, FeedViewAdapter>
    
    init(controller: ListViewController,
         imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher,
         selection: @escaping (FeedImage) -> Void = { _ in }) {
        self.controller = controller
        self.imageLoader = imageLoader
        self.selection = selection
    }
    
    func display(_ viewModel: Paginated<FeedImage>) {
        let feedSection: [CellController] = viewModel.items.map { model in
            let adapter = ImageDataPresentationAdapter(loader: { [imageLoader] in
                imageLoader(model.url)
            })
            
            let view = FeedImageCellController(viewModel: FeedImagePresenter.map(model), delegate: adapter) { [selection, model] in
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
        }
        
        guard let loadMorePublisher = viewModel.loadMorePublisher else {
            controller?.display(feedSection)
            return
        }
        let loadMoreAdapter = LoadMorePresentationAdapter { [loadMorePublisher] in
            loadMorePublisher().dispatchOnMainQueue()
        }
        let loadMore = LoadMoreCellController { [loadMoreAdapter] in
            loadMoreAdapter.loadResource()
        }
        
        loadMoreAdapter.presenter = LoadResourcePresenter(resourceView: self,
                                                          loadingView: WeakRefVirtualProxy(loadMore),
                                                          errorView: WeakRefVirtualProxy(loadMore),
                                                          mapper: { $0 })
    
        
        let loadMoreSection = [CellController(id: UUID(), loadMore)]
        
        controller?.display(feedSection, loadMoreSection)
    }
}

private struct InvalidImageData: Error {}
