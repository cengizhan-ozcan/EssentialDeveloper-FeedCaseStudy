//
//  ImageCommentPresenterTests.swift
//  EssentialImageCommentPresentationTests
//
//  Created by Cengizhan Özcan on 31.05.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import XCTest
import EssentialImageCommentPresentation

class ImageCommentPresenterTests: XCTestCase {
    
    func test_title_isLocalized() {
        XCTAssertEqual(ImageCommentPresenter.title, localized("IMAGE_COMMENTS_VIEW_TITLE"))
    }

    // MARK: - Helpers
    
    private func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "ImageComment"
        let bundle = Bundle(for: ImageCommentPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
