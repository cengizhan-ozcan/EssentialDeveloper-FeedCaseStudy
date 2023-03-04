//
//  FeedImageDataLoaderSpy.swift
//  EssentialAppTests
//
//  Created by Cengizhan Özcan on 4.03.2023.
//

import Foundation
import EssentialFeed

class FeedImageDataLoaderSpy: FeedImageDataLoader {
    
    private class Task: FeedImageDataLoaderTask {
        
        var completion: () -> Void
        
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
        return messages.map { $0.url }
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
