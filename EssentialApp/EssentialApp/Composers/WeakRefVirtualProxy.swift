//
//  WeakRefVirtualProxy.swift
//  EssentialFeediOS
//
//  Created by Cengizhan Özcan on 2.02.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import UIKit
import EssentialFeed
import EssentialFeediOS
import EssentialFeedPresentation

final class WeakRefVirtualProxy<T: AnyObject> {
    
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}


extension WeakRefVirtualProxy: ResourceLoadingView where T: ResourceLoadingView {
    
    func display(_ viewModel: ResouceLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: FeedImageView where T: FeedImageView, T.Image == UIImage {
    
    func display(_ viewModel: FeedImageViewModel<UIImage>) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: ResourceErrorView where T: ResourceErrorView {
    
    func display(_ viewModel: ResourceErrorViewModel) {
        object?.display(viewModel)
    }
}
