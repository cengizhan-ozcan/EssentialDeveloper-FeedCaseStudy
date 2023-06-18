//
//  FeedImageDataMapper.swift
//  EssentialFeedAPI
//
//  Created by Cengizhan Özcan on 18.06.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation

public class FeedImageDataMapper {
    
    public enum Error: Swift.Error {
        case invalidResponse
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> Data {
        guard response.isOK else {
            throw Error.invalidResponse
        }
        return data
    }
}
