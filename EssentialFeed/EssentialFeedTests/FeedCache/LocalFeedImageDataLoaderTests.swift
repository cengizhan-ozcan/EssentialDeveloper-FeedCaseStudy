//
//  LocalFeedImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Cengizhan Özcan on 25.02.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

protocol FeedImageDataStore {
    
    typealias Result = Swift.Result<Data?, Error>
    
    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}

final class LocalFeedImageDataLoader {
    
    private final class Task: FeedImageDataLoaderTask {
        
        private var completion: ((FeedImageDataLoader.Result) -> Void)?
        
        init(_ completion: (@escaping (FeedImageDataLoader.Result) -> Void)) {
            self.completion = completion
        }
        
        func complete(with result: FeedImageDataLoader.Result) {
            completion?(result)
        }
    
        func cancel() {
            preventFurtherCompletions()
        }
        
        private func preventFurtherCompletions() {
            completion = nil
        }
    }
    
    public enum Error: Swift.Error {
        case failed
        case notFound
    }
    
    let store: FeedImageDataStore
    
    init(store: FeedImageDataStore) {
        self.store = store
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = Task(completion)
        store.retrieve(dataForURL: url) { [weak self] result in
            guard self != nil else { return }
            
            task.complete(with: result
                                .mapError({ _ in Error.failed })
                                .flatMap({ data in data.map({ .success($0)}) ?? .failure(Error.notFound) }))
        }
        return task
    }
}

class LocalFeedImageDataLoaderTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receievedMessages.isEmpty)
    }
    
    func test_loadImageDataFromURL_requestsStoredDataForURL() {
        let (sut, store) = makeSUT()
        let url = anyURL()
        
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(store.receievedMessages, [.retrieve(dataFor: url)])
    }
    
    func test_loadImageDataFromURL_failsOnStoreError() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: failed()) {
            let retrievalError = anyError()
            store.complete(with: retrievalError)
        }
    }
    
    func test_loadImageDataFromURL_deliversNotFoundErrorOnNotFound() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: notFound()) {
            store.complete(with: .none)
        }
    }
    
    func test_loadImageDataFromURL_deliversStoredDataOnFoundData() {
        let (sut, store) = makeSUT()
        let data = anyData()
        
        expect(sut, toCompleteWith: .success(data)) {
            store.complete(with: data)
        }
    }
    
    func test_loadImageDataFromURL_doesNotDeliverResultAfterCancellingTask() {
        let (sut, store) = makeSUT()
        let data = anyData()
        
        var received = [FeedImageDataLoader.Result]()
        let task = sut.loadImageData(from: anyURL()) { received.append($0) }
        task.cancel()
        
        store.complete(with: data)
        store.complete(with: .none)
        store.complete(with: anyError())
        
        XCTAssertTrue(received.isEmpty, "Expected no received results after cancelling task")
    }
    
    func test_loadImageDataFromURL_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = StoreSpy()
        var sut: LocalFeedImageDataLoader? = LocalFeedImageDataLoader(store: store)
        
        var received = [FeedImageDataLoader.Result]()
        _ = sut?.loadImageData(from: anyURL(), completion: { received.append($0) })
        
        sut = nil
        store.complete(with: anyData())
        
        XCTAssertTrue(received.isEmpty, "Expected no received results after instace has been deallocated")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentData: @escaping () -> Date = Date.init,
                         file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: StoreSpy) {
        let store = StoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalFeedImageDataLoader, toCompleteWith expectedResult: FeedImageDataLoader.Result,
                        when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        _ = sut.loadImageData(from: anyURL()) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receievedData), .success(expectedData)):
                XCTAssertEqual(receievedData, expectedData, file: file, line: line)
            case let (.failure(receivedError as LocalFeedImageDataLoader.Error), .failure(expectedError as LocalFeedImageDataLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func failed() -> FeedImageDataLoader.Result {
        return .failure(LocalFeedImageDataLoader.Error.failed)
    }
    
    private func notFound() -> FeedImageDataLoader.Result {
        return .failure(LocalFeedImageDataLoader.Error.notFound)
    }
    
    private class StoreSpy: FeedImageDataStore {
        
        enum Message: Equatable {
            case retrieve(dataFor: URL)
        }
        
        private var completions = [(FeedImageDataStore.Result) -> Void]()
        private(set) var receievedMessages = [Message]()
        
        func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.Result) -> Void) {
            receievedMessages.append(.retrieve(dataFor: url))
            completions.append(completion)
        }
        
        func complete(with data: Data?, at index: Int = 0) {
            completions[index](.success(data))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            completions[index](.failure(error))
        }
    }
}