//
//  LocalFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Cengizhan Özcan on 25.02.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation
import EssentialFeed

public final class LocalFeedImageDataLoader {
    
    let store: FeedImageDataStore
    
    public init(store: FeedImageDataStore) {
        self.store = store
    }
}

extension LocalFeedImageDataLoader: FeedImageDataCache {
    
    public typealias SaveResult = FeedImageDataCache.Result
    
    public enum SaveError: Swift.Error {
        case failed
    }
    
    public func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void) {
        store.insert(data, for: url) { [weak self] result in
            guard self != nil else { return }
            completion(result
                .mapError({ _ in SaveError.failed }))
        }
    }
}

extension LocalFeedImageDataLoader: FeedImageDataLoader {
    
    public typealias LoadResult = FeedImageDataLoader.Result
    
    public enum LoadError: Swift.Error {
        case failed
        case notFound
    }
    
    private final class LoadImageTask: LoaderTask {
        
        private var completion: ((FeedImageDataLoader.Result) -> Void)?
        
        init(_ completion: (@escaping (FeedImageDataLoader.Result) -> Void)) {
            self.completion = completion
        }
        
        func complete(with result: FeedImageDataLoader.Result) {
            completion?(result)
        }
    
        func cancel() {
            preventFurtherCompletions()
        }
        
        private func preventFurtherCompletions() {
            completion = nil
        }
    }
    
    public func loadImageData(from url: URL, completion: @escaping (LoadResult) -> Void) -> LoaderTask {
        let task = LoadImageTask(completion)
        store.retrieve(dataForURL: url) { [weak self] result in
            guard self != nil else { return }
            
            task.complete(with: result
                                .mapError({ _ in LoadError.failed })
                                .flatMap({ data in data.map({ .success($0)}) ?? .failure(LoadError.notFound) }))
        }
        return task
    }
}
