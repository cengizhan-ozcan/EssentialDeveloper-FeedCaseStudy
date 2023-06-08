//
//  MainQueueDispatchDecorator.swift
//  EssentialFeediOS
//
//  Created by Cengizhan Özcan on 2.02.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation
import EssentialFeed
import SharedAPI

final class MainQueueDispatchDecorator<T> {
    
    private let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        completion()
    }
}

extension MainQueueDispatchDecorator: FeedLoader where T == FeedLoader {
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) -> LoaderTask {
        decoratee.load { [weak self] result in
            self?.dispatch(completion: { completion(result) })
        }
    }
}

extension MainQueueDispatchDecorator: ImageCommentLoader where T == ImageCommentLoader {
    
    func load(completion: @escaping (ImageCommentLoader.Result) -> Void) -> LoaderTask {
        decoratee.load { [weak self] result in
            self?.dispatch(completion: { completion(result) })
        }
    }
}

extension MainQueueDispatchDecorator: FeedImageDataLoader where T == FeedImageDataLoader {
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> LoaderTask {
        decoratee.loadImageData(from: url) { [weak self] result in
            self?.dispatch(completion: { completion(result) })
        }
    }
}
