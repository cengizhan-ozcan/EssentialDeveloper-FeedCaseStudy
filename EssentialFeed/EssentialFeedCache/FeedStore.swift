//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Cengizhan Özcan on 20.12.2022.
//  Copyright © 2022 Essential Developer. All rights reserved.
//

import Foundation

public typealias CachedFeed = (feed: [LocalFeedImage], timestamp: Date)

public protocol FeedStore {
    typealias DeletionResult = Result<Void, Error>
    typealias DeletionCompletion = (DeletionResult) -> Void
    
    typealias InsertionResult = Result<Void, Error>
    typealias InsertionCompletion = (InsertionResult) -> Void
    
    typealias RetrievalResult = Result<CachedFeed?, Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    
    /// The completion handler can be invoked in any thread
    /// Clients are responsible to dispatch to appropriate threads, if needed
    func deleteCachedFeed() throws
    
    /// The completion handler can be invoked in any thread
    /// Clients are responsible to dispatch to appropriate threads, if needed
    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws
    
    /// The completion handler can be invoked in any thread
    /// Clients are responsible to dispatch to appropriate threads, if needed
    func retrieve() throws -> CachedFeed?
    
    
    
    
    /// The completion handler can be invoked in any thread
    /// Clients are responsible to dispatch to appropriate threads, if needed
    @available(*, deprecated)
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    
    /// The completion handler can be invoked in any thread
    /// Clients are responsible to dispatch to appropriate threads, if needed
    @available(*, deprecated)
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
    
    /// The completion handler can be invoked in any thread
    /// Clients are responsible to dispatch to appropriate threads, if needed
    @available(*, deprecated)
    func retrieve(completion: @escaping RetrievalCompletion)
}

public extension FeedStore {
    
    func deleteCachedFeed() throws {
        let group = DispatchGroup()
        group.enter()
        
        var result: DeletionResult!
        deleteCachedFeed {
            result = $0
            group.leave()
        }
        group.wait()
        return try result.get()
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws {
        let group = DispatchGroup()
        group.enter()
        
        var result: InsertionResult!
        insert(feed, timestamp: timestamp) {
            result = $0
            group.leave()
        }
        
        group.wait()
        return try result.get()
    }
    
    func retrieve() throws -> CachedFeed? {
        let group = DispatchGroup()
        group.enter()
        
        var result: RetrievalResult!
        retrieve {
            result = $0
            group.leave()
        }
        
        group.wait()
        return try result.get()
    }
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {}
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {}
    func retrieve(completion: @escaping RetrievalCompletion) {}
}
