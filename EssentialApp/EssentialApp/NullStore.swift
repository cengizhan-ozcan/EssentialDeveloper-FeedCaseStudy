//
//  NullStore.swift
//  EssentialApp
//
//  Created by Cengizhan Özcan on 30.06.2023.
//

import Foundation
import EssentialFeedCache

class NullStore: FeedStore & FeedImageDataStore {
    
    func deleteCachedFeed() throws {
        
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws {
        
    }
    
    func retrieve() throws -> CachedFeed? {
        .none
    }
    
    func insert(_ data: Data, for url: URL) throws {
        
    }
    
    func retrieve(dataForURL url: URL) throws -> Data? {
        .none
    }
}
