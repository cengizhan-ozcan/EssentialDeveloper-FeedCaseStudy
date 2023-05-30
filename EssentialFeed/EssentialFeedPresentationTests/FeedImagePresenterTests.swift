//
//  FeedImagePresenterTests.swift
//  EssentialFeedPresentationTests
//
//  Created by Cengizhan Özcan on 27.05.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed
import EssentialFeedPresentation

class FeedImagePresenterTests: XCTestCase {
    
    func test_map_createsViewModel() {
        let image = FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())
        
        let viewModel = FeedImagePresenter.map(image)
        
        XCTAssertEqual(viewModel.description, image.description)
        XCTAssertEqual(viewModel.location, image.location)
    }
}

