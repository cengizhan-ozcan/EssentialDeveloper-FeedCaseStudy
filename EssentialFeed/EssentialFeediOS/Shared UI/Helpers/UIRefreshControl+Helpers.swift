//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by Cengizhan Özcan on 4.02.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import UIKit

extension UIRefreshControl {
    
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
