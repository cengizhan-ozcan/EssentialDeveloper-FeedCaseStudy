//
//  RemoteFeedImageDataLoaderAdapter.swift
//  EssentialApp
//
//  Created by Cengizhan Özcan on 18.06.2023.
//

import Foundation
import EssentialFeed
import EssentialFeedAPI
import SharedAPI

public class RemoteFeedImageDataLoaderAdapter: FeedImageDataLoader {
    
    private let client: HTTPClient
    private var remoteLoader: RemoteLoader<Data>?
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> LoaderTask {
        let remoteLoader = RemoteLoader(url: url, client: client, mapper: FeedImageDataMapper.map)
        self.remoteLoader = remoteLoader
        return remoteLoader.load(completion: completion)
    }
}
