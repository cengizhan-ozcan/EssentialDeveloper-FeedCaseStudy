//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Cengizhan Özcan on 28.02.2023.
//

import EssentialFeed

class FeedLoaderStub: FeedLoader {
    
    private class Task: LoaderTask {
        
        func cancel() {}
    }
    
    private let result: FeedLoader.Result
    
    init(result: FeedLoader.Result) {
        self.result = result
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) -> LoaderTask {
        completion(result)
        return Task()
    }
}
