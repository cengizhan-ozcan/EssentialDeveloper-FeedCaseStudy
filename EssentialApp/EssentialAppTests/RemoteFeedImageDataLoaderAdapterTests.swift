//
//  RemoteFeedImageDataLoaderAdapterTests.swift
//  EssentialAppTests
//
//  Created by Cengizhan Özcan on 18.06.2023.
//

import XCTest
import EssentialApp
import EssentialFeed
import SharedAPI

class RemoteFeedImageDataLoaderAdapterTests: XCTestCase {
    
    func test_init_doesNotLoadImageData() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty, "Expected no loaded URLs in the loader")
    }
    
    func test_loadImageData_loadsFromLoader() {
        let (sut, client) = makeSUT()
        let url = anyURL()
        
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadImageData_cancelsLoaderTask() {
        let (sut, client) = makeSUT()
        let url = anyURL()
        
        let task = sut.loadImageData(from: anyURL(), completion: { _ in })
        task.cancel()
        
        XCTAssertEqual(client.cancelledURLs, [url])
    }
    
    func test_loadImageData_deliversDataOnLoaderSuccess() {
        let (sut, client) = makeSUT()
        let imageData = anyData()
        
        expect(sut, toCompleteWith: .success(imageData)) {
            client.complete(with: imageData)
        }
    }
    
    func test_loadImageData_deliversErrorOnLoaderFailure() {
        let (sut, client) = makeSUT()
        let error = RemoteLoader<Data>.Error.connectivity
        
        expect(sut, toCompleteWith: .failure(error)) {
            client.complete(with: error)
        }
    }
    
    func test_loadImageData_deliversDataWhen10TimesCalledOnLoaderSuccess() {
        let (sut, client) = makeSUT()
        let imageData = anyData()
        
        for _ in 0..<10 {
            expect(sut, toCompleteWith: .success(imageData)) {
                client.complete(with: imageData)
            }
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RemoteFeedImageDataLoaderAdapter, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedImageDataLoaderAdapter(client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, client)
    }
    
    func expect(_ sut: RemoteFeedImageDataLoaderAdapter, toCompleteWith expectedResult: FeedImageDataLoader.Result,
                when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let expectation = expectation(description: "Wait for load completion")
        _ = sut.loadImageData(from: anyURL()) { recievedResult in
            switch (recievedResult, expectedResult) {
            case let (.success(receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                break
            default:
                XCTFail("Expected result \(expectedResult) got \(recievedResult) instead", file: file, line: line)
            }
            expectation.fulfill()
        }
        
        action()
        
        wait(for: [expectation], timeout: 1.0)
    }

    private class HTTPClientSpy: HTTPClient {
                
        private var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
        private(set) var cancelledURLs = [URL]()
        
        var requestedURLs: [URL] {
            messages.map { $0.url }
        }
        
        private struct Task: HTTPClientTask {
            
            let callback: () -> Void
            func cancel() { callback() }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
            messages.append((url, completion))
            return Task { [weak self] in
                self?.cancelledURLs.append(url)
            }
        }
        
        func complete(with data: Data, at index: Int = 0) {
            let url = requestedURLs[index]
            let response = HTTPURLResponse(url: url, statusCode: 200,
                                           httpVersion: nil, headerFields: nil)!

            messages[index].completion(.success((data, response)))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
    }
}

