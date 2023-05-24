//
//  ResourceErrorViewModel.swift
//  EssentialFeed
//
//  Created by Cengizhan Özcan on 4.02.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation

public struct ResourceErrorViewModel {

    public let message: String?
    
    public init(message: String? = nil) {
        self.message = message
    }
    
    public static var noError: ResourceErrorViewModel {
        return ResourceErrorViewModel(message: nil)
    }
    
    public static func error(message: String) -> ResourceErrorViewModel {
        return ResourceErrorViewModel(message: message)
    }
}
