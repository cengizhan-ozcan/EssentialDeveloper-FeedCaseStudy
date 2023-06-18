//
//  Paginated.swift
//  SharedAPI
//
//  Created by Cengizhan Özcan on 15.06.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation

public struct Paginated<Item> {
    public typealias LoadMoreCompletion = (Result<Paginated<Item>, Error>) -> Void
    
    public let items: [Item]
    public let loadMore: ((@escaping LoadMoreCompletion) -> Void)?
}
