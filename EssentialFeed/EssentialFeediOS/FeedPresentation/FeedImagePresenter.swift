//
//  FeedImagePresenter.swift
//  EssentialFeediOS
//
//  Created by Cengizhan Özcan on 29.01.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation
import EssentialFeed

public protocol FeedImageView {
    associatedtype Image
    
    func display(_ viewModel: FeedImageViewModel<Image>)
}

public final class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {
    
    private let view: View
    private let imageTransformer: (Data) -> Image?
    
    public init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }
    
    public func didStartLoadingImageData(for model: FeedImage) {
        view.display(FeedImageViewModel(description: model.description, location: model.location,
                                        image: nil, isLoading: true, shouldRetry: false))
    }
    
    private struct InvalidImageDataError: Error {}
    
    public func didFinishLoadingImageData(with data: Data, for model: FeedImage) {
        guard let image = imageTransformer(data) else {
            return didFinishLoadingImageData(with: InvalidImageDataError(), for: model)
        }
        view.display(FeedImageViewModel(description: model.description, location: model.location,
                                        image: image, isLoading: false, shouldRetry: false))
    }
    
    public func didFinishLoadingImageData(with: Error, for model: FeedImage) {
        view.display(FeedImageViewModel(description: model.description, location: model.location,
                                        image: nil, isLoading: false, shouldRetry: true))
    }
}

