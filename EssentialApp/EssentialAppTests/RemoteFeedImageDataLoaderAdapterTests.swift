//
//  RemoteFeedImageDataLoaderAdapterTests.swift
//  EssentialAppTests
//
//  Created by Cengizhan Özcan on 18.06.2023.
//

import XCTest
import EssentialFeed
import SharedAPI

class RemoteFeedImageDataLoaderAdapter {
    
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
}

class RemoteFeedImageDataLoaderAdapterTests: XCTestCase {
    
    func test_init_doesNotLoadImageData() {
        let client = HTTPClientSpy()
        let _ = RemoteFeedImageDataLoaderAdapter(client: client)
        
        XCTAssertTrue(client.requestedURLs.isEmpty, "Expected no loaded URLs in the loader")
    }
}


// MARK: - Helpers

class HTTPClientSpy: HTTPClient {
    
    var requestedURLs = [URL]()
    
    private class Task: HTTPClientTask {
        
        func cancel() {
            
        }
    }
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        requestedURLs.append(url)
        return Task()
    }
}

