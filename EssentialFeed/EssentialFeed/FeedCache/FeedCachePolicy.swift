//
//  FeedCachePolicy.swift
//  EssentialFeed
//
//  Created by Cengizhan Özcan on 23.12.2022.
//  Copyright © 2022 Essential Developer. All rights reserved.
//

import Foundation

internal final class FeedCachePolicy {

    private static let calendar = Calendar(identifier: .gregorian)
    
    private init() {}
    
    private static var maxCacheAgeInDays: Int {
        return 7
    }
    
    internal static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return date < maxCacheAge
    }
}
