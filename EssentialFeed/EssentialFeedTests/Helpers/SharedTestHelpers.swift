//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Cengizhan Özcan on 22.12.2022.
//  Copyright © 2022 Essential Developer. All rights reserved.
//

import Foundation

func anyError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyData() -> Data {
    return Data("any data".utf8)
}

