//
//  FeedImageDataCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Cengizhan Özcan on 4.03.2023.
//

import XCTest
import EssentialFeed

class FeedImageDataCacheDecorator: FeedImageDataLoader {
    
    let decoratee: FeedImageDataLoader
    
    init(decoratee: FeedImageDataLoader) {
        self.decoratee = decoratee
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        decoratee.loadImageData(from: url, completion: completion)
    }
}

class FeedImageDataCacheDecoratorTests: XCTestCase {
    
    func test_init_doesNotLoadImageData() {
        let loader = LoaderSpy()
        let sut = FeedImageDataCacheDecorator(decoratee: loader)
        
        XCTAssertTrue(loader.loadedURLs.isEmpty, "Expected no loaded URLs")
    }
    
    // MARK: - Helpers
    
    private class LoaderSpy: FeedImageDataLoader {
        
        private class Task: FeedImageDataLoaderTask {
            
            func cancel() {
                
            }
        }
        
        private var messages = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()
        
        var loadedURLs: [URL] {
            messages.map { $0.url }
        }
        
        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
            messages.append((url, completion))
            return Task()
        }
    }
}
