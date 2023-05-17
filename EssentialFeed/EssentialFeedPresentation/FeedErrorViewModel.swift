//
//  FeedErrorViewModel.swift
//  EssentialFeed
//
//  Created by Cengizhan Özcan on 4.02.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation

public struct FeedErrorViewModel {

    public let message: String?
    
    public init(message: String? = nil) {
        self.message = message
    }
    
    public static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }
    
    public static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}
