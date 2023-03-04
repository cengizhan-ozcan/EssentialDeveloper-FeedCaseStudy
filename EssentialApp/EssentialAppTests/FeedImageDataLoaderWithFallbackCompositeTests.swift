//
//  FeedImageDataLoaderWithFallbackCompositeTests.swift
//  EssentialAppTests
//
//  Created by Cengizhan Özcan on 26.02.2023.
//

import XCTest
import EssentialFeed
import EssentialApp

class FeedImageDataLoaderWithFallbackCompositeTests: XCTestCase {
    
    func test_init_doesNotLoadImageData() {
        let (_, primaryLoader, fallbackLoader) = makeSUT()
        
        XCTAssertTrue(primaryLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the primary loader")
        XCTAssertTrue(fallbackLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the fallback loader")
    }
    
    func test_loadImageData_loadsFromPrimaryLoaderFirst() {
        let url = anyURL()
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
        
        _ = sut.loadImageData(from: url, completion: { _ in })
        
        XCTAssertEqual(primaryLoader.loadedURLs, [url], "Expected to load URL in the primary loader")
        XCTAssertTrue(fallbackLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the fallback loader")
    }
    
    func test_loadImageData_loadsFromFallbackLoader() {
        let url = anyURL()
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
        
        _ = sut.loadImageData(from: url, completion: { _ in })
        
        primaryLoader.complete(with: anyError())
        
        XCTAssertEqual(primaryLoader.loadedURLs, [url], "Expected to load URL in the primary loader")
        XCTAssertEqual(fallbackLoader.loadedURLs, [url], "Expected loaded URLs in the fallback loader")
    }
    
    func test_cancelLoadImageData_cancelsPrimaryLoaderTask() {
        let url = anyURL()
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
        
        let task = sut.loadImageData(from: url) { _ in }
        task.cancel()
        
        XCTAssertEqual(primaryLoader.cancelledURLs, [url], "Expected to cancel URL in the primary loader")
        XCTAssertTrue(fallbackLoader.loadedURLs.isEmpty, "Expected no cancelled URLs in the fallback loader")
    }
    
    func test_cancelLoadImageData_cancelsFallbackLoaderTask() {
       let url = anyURL()
       let (sut, primaryLoader, fallbackLoader) = makeSUT()
       
       let task = sut.loadImageData(from: url, completion: { _ in })
       
       primaryLoader.complete(with: anyError())
       task.cancel()
       
       XCTAssertTrue(primaryLoader.cancelledURLs.isEmpty, "Expected no cancelled URLs in the primary loader")
       XCTAssertEqual(fallbackLoader.loadedURLs, [url], "Expected to cancel URL in the fallback loader")
    }
    
    func test_loadImageData_deliversPrimaryDataOnPrimarySuccess() {
        let data = anyData()
        let (sut, primaryLoader, _) = makeSUT()

        expect(sut, toCompleteWith: .success(data)) {
            primaryLoader.complete(with: data)
        }
    }
    
    func test_loadImageData_deliversFallbackDataOnPrimaryFailure() {
        let data = anyData()
        let (sut, primaryLoader, fallbackLoader) = makeSUT()

        expect(sut, toCompleteWith: .success(data)) {
            primaryLoader.complete(with: anyError())
            fallbackLoader.complete(with: data)
        }
    }
    
    func test_loadImageData_deliversErrorOnBothPrimaryAndFallbackLoaderFailure() {
        let (sut, primaryLoader, fallbackLoader) = makeSUT()

        expect(sut, toCompleteWith: .failure(anyError())) {
            primaryLoader.complete(with: anyError())
            fallbackLoader.complete(with: anyError())
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (FeedImageDataLoaderWithFallbackComposite,
                                                                             FeedImageDataLoaderSpy, FeedImageDataLoaderSpy) {
        let primaryImageDataLoader = FeedImageDataLoaderSpy()
        let fallbackImageDataLoader = FeedImageDataLoaderSpy()
        let sut = FeedImageDataLoaderWithFallbackComposite(primary: primaryImageDataLoader, fallback: fallbackImageDataLoader)
        trackForMemoryLeaks(primaryImageDataLoader, file: file, line: line)
        trackForMemoryLeaks(fallbackImageDataLoader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, primaryImageDataLoader, fallbackImageDataLoader)
    }
    
    private func expect(_ sut: FeedImageDataLoaderWithFallbackComposite, toCompleteWith expectedResult: FeedImageDataLoader.Result,
                        when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
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
        action()
        wait(for: [exp], timeout: 1.0)
    }
}
