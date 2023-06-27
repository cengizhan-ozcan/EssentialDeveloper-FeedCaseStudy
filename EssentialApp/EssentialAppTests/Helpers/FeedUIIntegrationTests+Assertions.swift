//
//  FeedUIIntegrationTests+Assertions.swift
//  EssentialFeediOSTests
//
//  Created by Cengizhan Özcan on 29.01.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation
import XCTest
import EssentialFeed
import EssentialFeediOS

extension FeedUIIntegrationTests {
    
    func assertThat(_ sut: ListViewController, hasViewConfiguredFor image: FeedImage, at index: Int,
                    file: StaticString = #file, line: UInt = #line) {
        let view = sut.feedImageView(at: index)
        
        guard let cell = view as? FeedImageCell else {
            return XCTFail("Expected \(FeedImageCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }
        
        let shouldLocationBeVisible = (image.location != nil)
        XCTAssertEqual(cell.isShowingLocation, shouldLocationBeVisible,
                       "Expected 'isShowingLocation' to be \(shouldLocationBeVisible) for image view at index (\(index))",
                       file: file, line: line)
        XCTAssertEqual(cell.locationText, image.location,
                       "Expected location text to be \(String(describing: image.location)) for image view at index (\(index))",
                       file: file, line: line)
        XCTAssertEqual(cell.descriptionText, image.description,
                       "Expected description text to be \(String(describing: image.description)) for image view at index (\(index))",
                       file: file, line: line)
    }
    
    func assertThat(_ sut: ListViewController, isRendering images: [FeedImage],
                            file: StaticString = #file, line: UInt = #line) {
        sut.tableView.layoutIfNeeded()
        RunLoop.main.run(until: Date())
        guard sut.numberOfRenderedFeedImageViews() == images.count else {
            return XCTFail("Expected \(images.count) images, got \(sut.numberOfRenderedFeedImageViews()) instead", file: file, line: line)
        }

        images.enumerated().forEach { (index, image) in
            assertThat(sut, hasViewConfiguredFor: image, at: index)
        }
    }
}
