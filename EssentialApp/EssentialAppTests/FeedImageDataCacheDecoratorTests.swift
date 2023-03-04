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
        let (_, loader) = makeSUT()
        
        XCTAssertTrue(loader.loadedURLs.isEmpty, "Expected no loaded URLs")
    }
    
    func test_loadImageData_loadsFromLoader() {
        let (sut, loader) = makeSUT()
        let url = anyURL()
        
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(loader.loadedURLs, [url], "Expected to load URL from loader")
    }
    
    func test_cancelLoadImageData_cancelsLoaderTask() {
        let (sut, loader) = makeSUT()
        let url = anyURL()
        
        let task = sut.loadImageData(from: url) { _ in }
        task.cancel()
        
        XCTAssertEqual(loader.cancelledURLs, [url], "Expected to cancelled URL from loader")
    }
    
    func test_loadImageData_deliversDataOnLoaderSuccess() {
        let (sut, loader) = makeSUT()
        let imageData = anyData()
        
        let exp = expectation(description: "Wait for load completion")
        _ = sut.loadImageData(from: anyURL(), completion: { result in
            switch result {
            case let .success(data):
                XCTAssertEqual(imageData, data)
            case .failure:
                XCTFail("Expected to load with success")
            }
            exp.fulfill()
        })
        loader.complete(with: imageData)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_loadImageData_deliversErrorOnLoaderFailure() {
        let (sut, loader) = makeSUT()
        let error = anyError()
        
        let exp = expectation(description: "Wait for load completion")
        _ = sut.loadImageData(from: anyURL(), completion: { result in
            switch result {
            case .success:
                XCTFail("Expected to load with error")
            case let .failure(receivedError as NSError):
                XCTAssertEqual(error, receivedError)
            }
            exp.fulfill()
        })
        loader.complete(with: error)
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedImageDataCacheDecorator, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedImageDataCacheDecorator(decoratee: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private class LoaderSpy: FeedImageDataLoader {
        
        private class Task: FeedImageDataLoaderTask {
            
            private var completion: (() -> Void)
            
            init(completion: @escaping () -> Void) {
                self.completion = completion
            }
            
            func cancel() {
                completion()
            }
        }
        
        private var messages = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()
        
        var cancelledURLs = [URL]()
        
        var loadedURLs: [URL] {
            messages.map { $0.url }
        }
        
        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
            messages.append((url, completion))
            return Task { [weak self] in
                self?.cancelledURLs.append(url)
            }
        }
        
        func complete(with data: Data, at index: Int = 0) {
            messages[index].completion(.success(data))
        }
        
        func complete(with error: NSError, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
    }
}
