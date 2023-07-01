//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Cengizhan Özcan on 4.03.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation

public protocol FeedCache {

    func save(_ feed: [FeedImage]) throws
}
