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
        let data = anyData()
        let sut = makeSUT(primaryResult: .success(data), fallbackResult: .success(data))
        
        expect(sut, toCompleteWith: .success(data))
    }
    
    // MARK: - Helpers
    
    private func makeSUT(primaryResult: FeedImageDataLoader.Result, fallbackResult: FeedImageDataLoader.Result,
                         file: StaticString = #file, line: UInt = #line) -> FeedImageDataLoaderWithFallbackComposite {
        let primaryImageDataLoader = ImageDataLoaderStub(result: primaryResult)
        let fallbackImageDataLoader = ImageDataLoaderStub(result: fallbackResult)
        let sut = FeedImageDataLoaderWithFallbackComposite(primary: primaryImageDataLoader, fallback: fallbackImageDataLoader)
        trackForMemoryLeaks(primaryImageDataLoader, file: file, line: line)
        trackForMemoryLeaks(fallbackImageDataLoader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func expect(_ sut: FeedImageDataLoaderWithFallbackComposite, toCompleteWith expectedResult: FeedImageDataLoader.Result,
                        file: StaticString = #file, line: UInt = #line) {
        let url = URL(string: "http://any-url.com")!
        let exp = expectation(description: "Wait for load completion")
        _ = sut.loadImageData(from: url) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)
            case (.failure, .failure):
                break
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak", file: file, line: line)
        }
    }
    
    private func anyData() -> Data {
        return Data("any data".utf8)
    }
    
    private func anyError() -> NSError {
        return NSError(domain: "any error", code: 0)
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
