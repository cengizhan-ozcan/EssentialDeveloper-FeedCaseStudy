//
//  SnapshotConfiguration.swift
//  EssentialFeediOSTests
//
//  Created by Cengizhan Özcan on 1.06.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import UIKit

struct SnapshotConfiguration {
    let size: CGSize
    let safeAreaInsets: UIEdgeInsets
    let layoutMargins: UIEdgeInsets
    let traitCollection: UITraitCollection
    
    // https://developer.apple.com/design/human-interface-guidelines/foundations/layout/
    static func iPhone8(style: UIUserInterfaceStyle) -> SnapshotConfiguration {
        return SnapshotConfiguration(size: CGSize(width: 375, height: 667),
                                     safeAreaInsets: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0),
                                     layoutMargins: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16),
                                     traitCollection: UITraitCollection(traitsFrom: [
                                        .init(forceTouchCapability: .available),
                                        .init(layoutDirection: .leftToRight),
                                        .init(preferredContentSizeCategory: .medium),
                                        .init(userInterfaceIdiom: .phone),
                                        .init(horizontalSizeClass: .compact),
                                        .init(verticalSizeClass: .regular),
                                        .init(displayScale: 2),
                                        .init(displayGamut: .P3),
                                        .init(userInterfaceStyle: style)
                                     ]))
    }
}
