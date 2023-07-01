//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Cengizhan Özcan on 20.12.2022.
//  Copyright © 2022 Essential Developer. All rights reserved.
//

import Foundation
import EssentialFeed

public final class LocalFeedLoader {
    
    private let store: FeedStore
    private let currentDate: () -> Date
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension LocalFeedLoader {
    
    public func load() throws -> [FeedImage] {
        do {
            let cachedFeed = try store.retrieve()
            if let cachedFeed = cachedFeed,
               FeedCachePolicy.validate(cachedFeed.timestamp, against: currentDate()) {
                return cachedFeed.feed.toModels()
            }
            return []
        } catch {
            throw error
        }
    }
}
    
extension LocalFeedLoader {
        
    public func validateCache() throws {
        do {
            let cachedFeed = try store.retrieve()
            if let cachedFeed = cachedFeed,
               !FeedCachePolicy.validate(cachedFeed.timestamp, against: currentDate()) {
                try store.deleteCachedFeed()
            }
        } catch {
            try store.deleteCachedFeed()
        }
    }
}
    
extension LocalFeedLoader: FeedCache {
    
    public func save(_ feed: [FeedImage]) throws {
        try store.deleteCachedFeed()
        try store.insert(feed.toLocal(), timestamp: currentDate())
    }
}

private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        return map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)}
    }
}

private extension Array where Element == LocalFeedImage {
    func toModels() -> [FeedImage] {
        return map { FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)}
    }
}
