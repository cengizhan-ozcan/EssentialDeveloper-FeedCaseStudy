//
//  UIViewController+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Cengizhan Özcan on 1.06.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func snapshot(for configuration: SnapshotConfiguration) -> UIImage {
        return SnapshotWindow(configuration: configuration, root: self).snapshot()
    }
}
