//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Cengizhan Özcan on 4.03.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation

public protocol FeedImageDataCache {
    typealias Result = Swift.Result<Void, Error>
    
    func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}
