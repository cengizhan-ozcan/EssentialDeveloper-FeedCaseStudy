//
//  FeedEndpoint.swift
//  EssentialFeedAPI
//
//  Created by Cengizhan Özcan on 26.06.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation

public enum FeedEndpoint {
    
    case get
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            return baseURL.appendingPathComponent("/v1/feed")
        }
    }
}
