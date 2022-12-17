//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Cengizhan Özcan on 14.12.2022.
//  Copyright © 2022 Essential Developer. All rights reserved.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
