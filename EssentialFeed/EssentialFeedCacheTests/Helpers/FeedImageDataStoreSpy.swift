//
//  FeedImageDataStoreSpy.swift
//  EssentialFeedTests
//
//  Created by Cengizhan Özcan on 25.02.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation
import EssentialFeed
import EssentialFeedCache

class FeedImageDataStoreSpy: FeedImageDataStore {
    
    enum Message: Equatable {
        case insert(data: Data, for: URL)
        case retrieve(dataFor: URL)
    }
    
    private var insertionResult: Result<Void, Error>?
    private var retrievalResult: Result<Data?, Error>?
    private(set) var receievedMessages = [Message]()
    
    func insert(_ data: Data, for url: URL) throws {
        receievedMessages.append(.insert(data: data, for: url))
        try insertionResult?.get()
    }
    
    func retrieve(dataForURL url: URL) throws -> Data? {
        receievedMessages.append(.retrieve(dataFor: url))
        return try retrievalResult?.get()
    }
    
    func completeInsertion(at index: Int = 0) {
        insertionResult = .success(())
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionResult = .failure(error)
    }
    
    func completeRetrieval(with data: Data?, at index: Int = 0) {
        retrievalResult = .success(data)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalResult = .failure(error)
    }
}
