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
    private var remoteLoaders = [UUID:RemoteLoader<Data>]()
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> LoaderTask {
        let remoteLoader = RemoteLoader(url: url, client: client, mapper: FeedImageDataMapper.map)
        let id = UUID()
        remoteLoaders[id] = remoteLoader
        // TODO: Fix.
        return remoteLoaders[id]!.load(completion: { [weak self, id] result in
            self?.remoteLoaders[id] = nil
            completion(result)
        }) as! LoaderTask
    }
}
