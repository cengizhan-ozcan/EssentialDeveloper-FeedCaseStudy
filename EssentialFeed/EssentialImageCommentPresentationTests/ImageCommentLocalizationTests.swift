//
//  ImageCommentLocalizationTests.swift
//  EssentialImageCommentPresentationTests
//
//  Created by Cengizhan Özcan on 31.05.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed
import EssentialImageCommentPresentation

final class ImageCommentLocalizationTests: XCTestCase {
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "ImageComment"
        let bundle = Bundle(for: ImageCommentPresenter.self)
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
}
