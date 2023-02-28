//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Cengizhan Özcan on 28.02.2023.
//

import Foundation
import EssentialFeed

func anyError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyData() -> Data {
    return Data("any data".utf8)
}

func uniqueFeed() -> [FeedImage] {
    return [FeedImage(id: UUID(), description: "any", location: "any", url: URL(string: "http://any-url.com")!)]
}
