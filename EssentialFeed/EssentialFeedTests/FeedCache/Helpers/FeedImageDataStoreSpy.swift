//
//  FeedImageDataStoreSpy.swift
//  EssentialFeedTests
//
//  Created by Cengizhan Özcan on 25.02.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation
import EssentialFeed

class FeedImageDataStoreSpy: FeedImageDataStore {
    
    enum Message: Equatable {
        case insert(data: Data, for: URL)
        case retrieve(dataFor: URL)
    }
    
    private var insertionCompletions = [(FeedImageDataStore.InsertionResult) -> Void]()
    private var retrievalCompletions = [(FeedImageDataStore.RetrievalResult) -> Void]()
    private(set) var receievedMessages = [Message]()
    
    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {
        receievedMessages.append(.insert(data: data, for: url))
        insertionCompletions.append(completion)
    }
    
    func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
        receievedMessages.append(.retrieve(dataFor: url))
        retrievalCompletions.append(completion)
    }
    
    func completeInsertion(at index: Int = 0) {
        insertionCompletions[index](.success(()))
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](.failure(error))
    }
    
    func completeRetrieval(with data: Data?, at index: Int = 0) {
        retrievalCompletions[index](.success(data))
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
}
