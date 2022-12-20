//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Cengizhan Özcan on 14.12.2022.
//  Copyright © 2022 Essential Developer. All rights reserved.
//

import Foundation

final class FeedItemsMapper {
    
    private static var OK_200: Int { return 200 }
    
    private struct Root: Decodable {
        var items: [RemoteFeedItem]
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data)else {
            throw RemoteFeedLoader.Error.invalidData
        }
        return root.items
    }
}
