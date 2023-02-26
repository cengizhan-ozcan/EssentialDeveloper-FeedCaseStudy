//
//  FeedImageDataLoaderWithFallbackCompositeTests.swift
//  EssentialAppTests
//
//  Created by Cengizhan Özcan on 26.02.2023.
//

import XCTest
import EssentialFeed

class FeedImageDataLoaderWithFallbackComposite: FeedImageDataLoader {
    
    let primary: FeedImageDataLoader
    
    init(primary: FeedImageDataLoader, fallback: FeedImageDataLoader) {
        self.primary = primary
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        return primary.loadImageData(from: url, completion: completion)
    }
}

class FeedImageDataLoaderWithFallbackCompositeTests: XCTestCase {
    
    func test_loadData_deliversPrimaryFeedImageOnPrimarySuccess() {
        let url = URL(string: "http://any-url.com")!
        let data = anyData()
        let primaryImageDataLoader = ImageDataLoaderStub(result: .success(data))
        let fallbackImageDataLoader = ImageDataLoaderStub(result: .success(data))
        let sut = FeedImageDataLoaderWithFallbackComposite(primary: primaryImageDataLoader, fallback: fallbackImageDataLoader)
        
        let exp = expectation(description: "Wait for load completion")
        _ = sut.loadImageData(from: url) { result in
            switch result {
            case let .success(receivedData):
                XCTAssertEqual(receivedData, data)
            case .failure:
                XCTFail("Expected to success, got \(result) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func anyData() -> Data {
        return Data("any data".utf8)
    }
    
    private class ImageDataLoaderStub: FeedImageDataLoader {
        
        private class Task: FeedImageDataLoaderTask {
            
            func cancel() {
                
            }
        }
        
        let result: FeedImageDataLoader.Result
        
        init(result: FeedImageDataLoader.Result) {
            self.result = result
        }
        
        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
            completion(result)
            return Task()
        }
    }
}
