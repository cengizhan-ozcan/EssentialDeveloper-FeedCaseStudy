//
//  RemoteFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Cengizhan Özcan on 25.02.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation

public final class RemoteFeedImageDataLoader {
    
    private final class HTTPClientTaskWrapper: FeedImageDataLoaderTask {
        
        private var completion: ((FeedImageDataLoader.Result) -> Void)?
        
        var wrapper: HTTPClientTask?
        
        init(_ completion: @escaping (FeedImageDataLoader.Result) -> Void) {
            self.completion = completion
        }
        
        func complete(with result: FeedImageDataLoader.Result) {
            completion?(result)
        }
        
        func cancel() {
            preventFurtherCompletions()
            wrapper?.cancel()
        }
        
        private func preventFurtherCompletions() {
            completion = nil
        }
    }
    
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    @discardableResult
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = HTTPClientTaskWrapper(completion)
        task.wrapper = client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                if response.statusCode == 200 && !data.isEmpty {
                    task.complete(with: .success(data))
                    return
                }
                task.complete(with: .failure(Error.invalidData))
            case let .failure(error):
                task.complete(with: .failure(error))
            }
        }
        return task
    }
}
