//
//  FeedUIIntegrationTests+LoaderSpy.swift
//  EssentialFeediOSTests
//
//  Created by Cengizhan Özcan on 29.01.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation
import EssentialFeed
import EssentialFeediOS

extension FeedUIIntegrationTests {
    
    class LoaderSpy: FeedLoader, FeedImageDataLoader {
        
        private struct TaskSpy: LoaderTask {
            
            let cancelCallback: () -> Void
            
            func cancel() {
                cancelCallback()
            }
        }
        
        // MARK: - FeedLoader
        private var feedRequests = [(FeedLoader.Result) -> Void]()
        private(set) var feedCancelCount = 0
        
        var loadFeedCallCount: Int {
            return feedRequests.count
        }
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) -> LoaderTask {
            feedRequests.append(completion)
            return TaskSpy { [weak self] in
                self?.feedCancelCount += 1
            }
        }
        
        func completeFeedLoading(with feed: [FeedImage] = [], at index: Int = 0) {
            feedRequests[index](.success(feed))
        }
        
        func completeFeedLoadingWithError(at index: Int = 0) {
            feedRequests[index](.failure(anyError()))
        }
        
        // MARK: - FeedImageDataLoader
        
        private var imageRequests = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()
        
        private(set) var cancelledImageURLs = [URL]()
        
        var loadedImageURLs: [URL] {
            return imageRequests.map { $0.url }
        }
        
        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> LoaderTask {
            imageRequests.append((url, completion))
            return TaskSpy { [weak self] in self?.cancelledImageURLs.append(url) }
        }
        
        func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
            imageRequests[index].completion(.success(imageData))
        }
        
        func completeImageLoadingWithError(at index: Int = 0) {
            imageRequests[index].completion(.failure(anyError()))
        }
    }
}
