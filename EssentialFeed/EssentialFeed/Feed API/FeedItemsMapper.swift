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
        var items: [Item]
        
        var feedItems: [FeedItem] {
            return items.map({ $0.item })
        }
    }

    private struct Item: Decodable {
        public let id: UUID
        public let description: String?
        public let location: String?
        public let image: URL
        
        var item: FeedItem {
            return FeedItem(id: id, description: description, location: location, imageURL: image)
        }
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data)else {
            return .failure(RemoteFeedLoader.Error.invalidData)
        }
        return .success(root.feedItems)
    }
}
