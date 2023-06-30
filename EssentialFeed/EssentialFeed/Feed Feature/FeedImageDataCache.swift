//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Cengizhan Özcan on 30.06.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation

public protocol FeedImageDataCache {
    
    func save(_ data: Data, for url: URL) throws
}
