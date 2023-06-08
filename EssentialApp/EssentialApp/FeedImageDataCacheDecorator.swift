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
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> LoaderTask {
        decoratee.loadImageData(from: url) { [weak self] result in
            completion(result.map({ data in
                self?.cache.saveIgnoringResult(data, for: url)
                return data
            }))
        }
    }
}

extension FeedImageDataCache {
    
    func saveIgnoringResult(_ data: Data, for url: URL) {
        save(data, for: url) { _ in }
    }
}
