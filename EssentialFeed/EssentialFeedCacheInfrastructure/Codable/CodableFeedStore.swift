//
//  CodableFeedStore.swift
//  EssentialFeed
//
//  Created by Cengizhan Özcan on 7.01.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation
import EssentialFeedCache

// NOT: CodableFeedStore classı ve testleri CoreData kullanılacağı için silindi. Fakat ileriye dönük örnek kod olması amacıyla tutuyorum.

public class CodableFeedStore: FeedStore {
    
    
    private struct Cache: Codable {
        let feed: [CodableFeedImage]
        let timestamp: Date
        
        var localFeed: [LocalFeedImage] {
            return feed.map( { $0.local })
        }
    }
    
    private struct CodableFeedImage: Codable {
        private let id: UUID
        private let description: String?
        private let location: String?
        private let url: URL
        
        init(_ image: LocalFeedImage) {
            id = image.id
            description = image.description
            location = image.location
            url = image.url
        }
        
        var local: LocalFeedImage {
            return LocalFeedImage(id: id, description: description, location: location, url: url)
        }
    }
    
    private let storeURL: URL
    
    public init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    public func retrieve() throws -> CachedFeed? {
        let storeURL = self.storeURL
        guard let data = try? Data(contentsOf: storeURL) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        let cache = try decoder.decode(Cache.self, from: data)
        return CachedFeed(feed: cache.localFeed, timestamp: cache.timestamp)
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date) throws {
        let storeURL = self.storeURL
        let encoder = JSONEncoder()
        let cache = Cache(feed: feed.map(CodableFeedImage.init), timestamp: timestamp)
        let encoded = try encoder.encode(cache)
        try encoded.write(to: storeURL)
    }
    
    public func deleteCachedFeed() throws {
        let storeURL = self.storeURL
        guard FileManager.default.fileExists(atPath: storeURL.path) else {
            return
        }
        
        try FileManager.default.removeItem(at: storeURL)
    }
}
