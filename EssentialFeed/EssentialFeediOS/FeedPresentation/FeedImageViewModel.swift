//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Cengizhan Özcan on 29.01.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation

public struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        return location != nil
    }
    
    public init(description: String?, location: String?, image: Image?, isLoading: Bool, shouldRetry: Bool) {
        self.description = description
        self.location = location
        self.image = image
        self.isLoading = isLoading
        self.shouldRetry = shouldRetry
    }
}
