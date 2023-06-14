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
    static func iPhone8(style: UIUserInterfaceStyle, contentSize: UIContentSizeCategory = .medium) -> SnapshotConfiguration {
        return SnapshotConfiguration(size: CGSize(width: 375, height: 667),
                                     safeAreaInsets: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0),
                                     layoutMargins: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16),
                                     traitCollection: UITraitCollection(traitsFrom: [
                                        .init(forceTouchCapability: .available),
                                        .init(layoutDirection: .leftToRight),
                                        .init(preferredContentSizeCategory: contentSize),
                                        .init(userInterfaceIdiom: .phone),
                                        .init(horizontalSizeClass: .compact),
                                        .init(verticalSizeClass: .regular),
                                        .init(displayScale: 2),
                                        .init(displayGamut: .P3),
                                        .init(userInterfaceStyle: style)
                                     ]))
    }
    
    static func iPhone13(style: UIUserInterfaceStyle, contentSize: UIContentSizeCategory = .medium) -> SnapshotConfiguration {
        return SnapshotConfiguration(
            size: CGSize(width: 390, height: 844),
            safeAreaInsets: UIEdgeInsets(top: 47, left: 0, bottom: 34, right: 0),
            layoutMargins: UIEdgeInsets(top: 55, left: 8, bottom: 42, right: 8),
            traitCollection: UITraitCollection(traitsFrom: [
                .init(forceTouchCapability: .unavailable),
                .init(layoutDirection: .leftToRight),
                .init(preferredContentSizeCategory: contentSize),
                .init(userInterfaceIdiom: .phone),
                .init(horizontalSizeClass: .compact),
                .init(verticalSizeClass: .regular),
                .init(displayScale: 3),
                .init(accessibilityContrast: .normal),
                .init(displayGamut: .P3),
                .init(userInterfaceStyle: style)
            ]))
    }
}
