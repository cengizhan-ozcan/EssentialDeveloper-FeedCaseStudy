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
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host()
            components.path = baseURL.path() + "/v1/feed"
            components.queryItems = [
                URLQueryItem(name: "limit", value: "10")
            ]
            return components.url!
        }
    }
}