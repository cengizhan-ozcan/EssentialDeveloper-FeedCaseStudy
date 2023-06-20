//
//  RemoteLoader.swift
//  SharedAPI
//
//  Created by Cengizhan Özcan on 20.03.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation

public final class RemoteLoader<Resource> {
    
    public typealias Result = Swift.Result<Resource, Swift.Error>
    public typealias Mapper = (Data, HTTPURLResponse) throws -> Resource
    
    private let url: URL
    private let client: HTTPClient
    private let mapper: Mapper
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public final class RemoteLoaderTask {
        
        private var completion: ((Result) -> Void)?
        
        fileprivate var wrapper: HTTPClientTask?
        
        fileprivate init(_ completion: @escaping (Result) -> Void) {
            self.completion = completion
        }
        
        fileprivate func complete(with result: Result) {
            completion?(result)
        }
        
        public func cancel() {
            preventFurtherCompletions()
            wrapper?.cancel()
        }
        
        private func preventFurtherCompletions() {
            completion = nil
        }
    }
    
    public init(url: URL, client: HTTPClient, mapper: @escaping Mapper) {
        self.url = url
        self.client = client
        self.mapper = mapper
    }
    
    public func load(completion: @escaping (Result) -> Void) -> RemoteLoaderTask {
        let task = RemoteLoaderTask(completion)
        task.wrapper = client.get(from: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success((data, response)):
                task.complete(with: self.map(data, from: response))
            case .failure:
                task.complete(with: .failure(Error.connectivity))
            }
        }
        return task
    }
    
    private func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try mapper(data, response)
            return .success(items)
        } catch {
            return .failure(Error.invalidData)
        }
    }
}
