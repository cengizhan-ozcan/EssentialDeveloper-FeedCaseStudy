//
//  FeedImageDataMapper.swift
//  EssentialFeedAPITests
//
//  Created by Cengizhan Özcan on 18.06.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeedAPI

class FeedImageDataMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let samples = [199, 201, 300, 400, 500]
        let json = makeItemsJSON([])
        
        try samples.forEach({ sample in
            XCTAssertThrowsError(
                try FeedImageDataMapper.map(json, from: HTTPURLResponse(statusCode: sample))
            )
        })
    }
    
    func test_map_deliversDataOn200HTTPResponseWithAnyData() throws {
        let data = anyData()
        let receivedData = try FeedImageDataMapper.map(data, from: HTTPURLResponse(statusCode: 200))
        XCTAssertEqual(data, receivedData)
    }
}
