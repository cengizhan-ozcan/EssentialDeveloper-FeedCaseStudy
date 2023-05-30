//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Cengizhan Özcan on 29.01.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?
    
    public var hasLocation: Bool {
        return location != nil
    }
    
    public init(description: String?, location: String?) {
        self.description = description
        self.location = location
    }
}
