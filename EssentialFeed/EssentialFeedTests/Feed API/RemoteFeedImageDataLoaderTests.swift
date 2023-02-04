//
//  RemoteFeedImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Cengizhan Özcan on 4.02.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class RemoteFeedImageDataLoader {
    
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            default:
                break
            }
        }
    }
}

class RemoteFeedImageDataLoaderTests: XCTestCase {
    
    func test_init_doesNotPerformAnyRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_loadImageDataFromURL_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT()
        
        sut.loadImageData(from: url) { _ in }
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadImageDataFromURLTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT()
        
        sut.loadImageData(from: url) { _ in }
        sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_loadImageDataFromURL_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        let error = anyError()
        
        expect(sut, toCompleteWith: .failure(error)) {
            client.complete(with: error)
        }
    }
     
    // MARK: - Helper
    
    private func makeSUT(url: URL = anyURL(), file: StaticString = #file, line: UInt = #line) -> (sut: RemoteFeedImageDataLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedImageDataLoader(client: client)
        trackForMemoryLeaks(client)
        trackForMemoryLeaks(sut)
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteFeedImageDataLoader, toCompleteWith expectedResult: FeedImageDataLoader.Result,
                        when action: () -> Void, file:   StaticString = #file, line: UInt = #line) {
        let url = URL(string: "https://a-given-url.com")!
        let expectation = expectation(description: "Wait for load completion")
        sut.loadImageData(from: url) { recievedResult in
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
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
    }
}
