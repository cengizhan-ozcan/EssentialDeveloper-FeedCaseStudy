//
//  RemoteLoader.swift
//  SharedAPI
//
//  Created by Cengizhan Özcan on 20.03.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation
import EssentialFeed

public final class RemoteLoader: FeedLoader {
    
    public typealias Result = FeedLoader.Result
    
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                completion(RemoteLoader.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
//            let items = try FeedItemsMapper.map(data, from: response)
            return .success([])
        } catch {
            return .failure(error)
        }
    }
}
