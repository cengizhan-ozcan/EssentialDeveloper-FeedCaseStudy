//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Cengizhan Özcan on 25.02.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation

public protocol FeedImageDataStore {
    
    func insert(_ data: Data, for url: URL) throws
    func retrieve(dataForURL url: URL) throws -> Data?
}
