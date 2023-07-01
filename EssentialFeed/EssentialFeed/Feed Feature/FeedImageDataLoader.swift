//
//  FeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Cengizhan Özcan on 22.01.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation

public protocol FeedImageDataLoader {

    func loadImageData(from url: URL) throws -> Data
}
