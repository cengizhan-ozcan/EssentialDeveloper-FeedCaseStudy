//
//  UITableView+Dequeueing.swift
//  EssentialFeediOS
//
//  Created by Cengizhan Özcan on 29.01.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import UIKit

extension UITableView {
    
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifider = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifider) as! T
    }
}
