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
import Combine

final class LoadResourcePresentationAdapter<Resource, View: ResourceView>{
    
    private let loader: () -> AnyPublisher<Resource, Error>
    private var cancellable: AnyCancellable?
    var presenter: LoadResourcePresenter<Resource, View>?
    
    init(loader: @escaping () -> AnyPublisher<Resource, Error>) {
        self.loader = loader
    }
    
    func loadResource() {
        presenter?.didStartLoading()
        
        cancellable = loader().sink(
            receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished: break
                case let .failure(error):
                    self?.presenter?.didFinishLoading(with: error)
                }
            }, receiveValue: { [weak self] resource in
                self?.presenter?.didFinishLoading(with: resource)
            })
    }
}

extension LoadResourcePresentationAdapter: FeedImageCellControllerDelegate where Resource == Data {
    
    func didRequestImage() {
        loadResource()
    }
    
    func didCancelImageRequest() {
        cancellable?.cancel()
        cancellable = nil
    }
}
