//
//  FeedViewModel.swift
//  EssentialFeed
//
//  Created by Cengizhan Özcan on 4.02.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation
import EssentialFeed

public struct FeedViewModel {
   
    public let feed: [FeedImage]
    
    public init(feed: [FeedImage]) {
        self.feed = feed
    }
}
