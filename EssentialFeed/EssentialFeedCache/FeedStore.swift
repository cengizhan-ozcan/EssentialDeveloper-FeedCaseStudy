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
    /// The completion handler can be invoked in any thread
    /// Clients are responsible to dispatch to appropriate threads, if needed
    func deleteCachedFeed() throws
    
    /// The completion handler can be invoked in any thread
    /// Clients are responsible to dispatch to appropriate threads, if needed
    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws
    
    /// The completion handler can be invoked in any thread
    /// Clients are responsible to dispatch to appropriate threads, if needed
    func retrieve() throws -> CachedFeed?
}
