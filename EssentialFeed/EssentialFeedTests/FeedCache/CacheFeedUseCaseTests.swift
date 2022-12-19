//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Cengizhan Özcan on 19.12.2022.
//  Copyright © 2022 Essential Developer. All rights reserved.
//

import XCTest

class LocalFeedLoader{
        
    init(store: FeedStore) {
        
    }
}

class FeedStore {
    var deletedCachedFeedCallCount = 0
}

class CacheFeedUseCaseTests: XCTestCase {
    
    func test_init_doesNotDeleteCacheUponCreation() {
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)
        XCTAssertEqual(store.deletedCachedFeedCallCount, 0)
    }
}
