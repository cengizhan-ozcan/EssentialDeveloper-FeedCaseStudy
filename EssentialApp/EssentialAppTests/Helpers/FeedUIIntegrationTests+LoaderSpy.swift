//
//  FeedUIIntegrationTests+LoaderSpy.swift
//  EssentialFeediOSTests
//
//  Created by Cengizhan Özcan on 29.01.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Combine
import Foundation
import EssentialFeed
import EssentialFeediOS
import SharedAPI

extension FeedUIIntegrationTests {
    
    class LoaderSpy: FeedImageDataLoader {
        
        // MARK: - FeedLoader
        private var feedRequests = [PassthroughSubject<Paginated<FeedImage>, Error>]()
        
        var loadFeedCallCount: Int {
            return feedRequests.count
        }
        
        var feedCancelCount = 0
        
        func loadPublisher() -> AnyPublisher<Paginated<FeedImage>, Error> {
            let publisher = PassthroughSubject<Paginated<FeedImage>, Error>()
            feedRequests.append(publisher)
            return publisher.handleEvents(receiveCancel: { [weak self] in
                self?.feedCancelCount += 1
            }).eraseToAnyPublisher()
        }
        
        func completeFeedLoading(with feed: [FeedImage] = [], at index: Int = 0) {
            feedRequests[index].send(Paginated(items: feed))
        }
        
        func completeFeedLoadingWithError(at index: Int = 0) {
            feedRequests[index].send(completion: .failure(anyError()))
        }
        
        // MARK: - FeedImageDataLoader
        
        private struct TaskSpy: FeedImageDataLoaderTask {
            
            let cancelCallback: () -> Void
            
            func cancel() {
                cancelCallback()
            }
        }
        
        private var imageRequests = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()
        
        private(set) var cancelledImageURLs = [URL]()
        
        var loadedImageURLs: [URL] {
            return imageRequests.map { $0.url }
        }
        
        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
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
