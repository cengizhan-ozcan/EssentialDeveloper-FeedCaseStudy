//
//  ImageCommentsMapper.swift
//  EssentialFeedAPI
//
//  Created by Cengizhan Özcan on 13.03.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation

final class ImageCommentsMapper {
    
    private struct Root: Decodable {
        var items: [RemoteFeedItem]
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard isOK(response), let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteImageCommentsLoader.Error.invalidData
        }
        return root.items
    }
    
    private static func isOK(_ response: HTTPURLResponse) -> Bool {
        (200...299).contains(response.statusCode)
    }
}
