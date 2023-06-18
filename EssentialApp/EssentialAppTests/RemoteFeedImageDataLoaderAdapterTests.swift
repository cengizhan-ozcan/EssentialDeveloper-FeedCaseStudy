//
//  RemoteFeedImageDataLoaderAdapterTests.swift
//  EssentialAppTests
//
//  Created by Cengizhan Özcan on 18.06.2023.
//

import XCTest
import EssentialFeed
import SharedAPI

class RemoteFeedImageDataLoaderAdapter: FeedImageDataLoader {
    
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> LoaderTask {
        let remoteLoader = RemoteLoader(url: url, client: client) { data,response in
            return data
        }
        return remoteLoader.load(completion: completion)
    }
}

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
    
    
    // MARK: - Helpers
    
    private func makeSUT(client: HTTPClientSpy = .init(), file: StaticString = #file, line: UInt = #line) -> (sut: RemoteFeedImageDataLoaderAdapter, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedImageDataLoaderAdapter(client: client)
        return (sut, client)
    }

    private class HTTPClientSpy: HTTPClient {
        
        var requestedURLs = [URL]()
        var cancelledURLs = [URL]()
        
        private struct Task: HTTPClientTask {
            
            let callback: () -> Void
            func cancel() { callback() }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
            requestedURLs.append(url)
            return Task { [weak self, url] in
                self?.cancelledURLs.append(url)
            }
        }
    }
}
