//
//  FeedImageDataCacheDecorator.swift
//  EssentialApp
//
//  Created by Cengizhan Özcan on 4.03.2023.
//

import Foundation
import EssentialFeed

public class FeedImageDataCacheDecorator: FeedImageDataLoader {
    
    private let decoratee: FeedImageDataLoader
    private let cache: FeedImageDataCache
    
    public init(decoratee: FeedImageDataLoader, cache: FeedImageDataCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        decoratee.loadImageData(from: url) { [weak self] result in
            completion(result.map({ data in
                self?.cache.save(data, for: url) { _ in }
                return data
            }))
        }
    }
}
