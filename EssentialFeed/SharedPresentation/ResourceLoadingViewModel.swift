//
//  ResourceLoadingViewModel.swift
//  EssentialFeed
//
//  Created by Cengizhan Özcan on 4.02.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation

public struct ResourceLoadingViewModel {
    
    public let isLoading: Bool

    public init(isLoading: Bool) {
        self.isLoading = isLoading
    }
}
