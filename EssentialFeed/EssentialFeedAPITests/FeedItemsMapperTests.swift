//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed
import EssentialFeedAPI

class FeedItemsMapperTests: XCTestCase {
	
	func test_map_throwsErrorOnNon200HTTPResponse() throws{
		let samples = [199, 201, 300, 400, 500]
        let json = makeItemsJSON([])
        
		try samples.forEach { code in
            XCTAssertThrowsError(
                try FeedItemsMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
		}
	}
	
	func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() throws {
        let invalidJSON = Data("invalid json".utf8)
        XCTAssertThrowsError(
            try FeedItemsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
	}
    
    func test_map_deliversNoItemOn200HTTPResponseWithEmptyJSONList() throws {
        let json = makeItemsJSON([])
        
        let result = try FeedItemsMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [], "Expected to get empty list with no item")
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
   
        let item1 = makeItem(id: UUID(), image: "http://a-url.com")
        let item2 = makeItem(id: UUID(), description: "a description",
                                           location: "a location", image: "http://a-url.com")
        
        let json = makeItemsJSON([item1.json, item2.json])
        let result = try FeedItemsMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [item1.model, item2.model])
    }

	// MARK: - Helpers
    
    private func makeItem(id: UUID, description: String? = nil, location: String? = nil, image: String) -> (model: FeedImage, json: [String:Any]) {
        let item = FeedImage(id: id, description: description, location: location, url: URL(string: image)!)
        let json: [String:Any] = ["id": id.uuidString,
                                  "description": description,
                                  "location": location,
                                  "image": image].compactMapValues({ $0 })

        return (item, json)
    }
}
