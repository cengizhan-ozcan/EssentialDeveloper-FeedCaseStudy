//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Cengizhan Özcan on 14.12.2022.
//  Copyright © 2022 Essential Developer. All rights reserved.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    /// The completion handler can be invoked in any thread
    /// Clients are responsible to dispatch to appropriate threads, if needed
    func get(from url: URL, completion: @escaping (Result) -> Void)
}
