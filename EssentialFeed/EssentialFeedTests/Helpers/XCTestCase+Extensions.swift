//
//  XCTestCase+Extensions.swift
//  EssentialFeedTests
//
//  Created by Cengizhan Özcan on 16.12.2022.
//  Copyright © 2022 Essential Developer. All rights reserved.
//

import XCTest

extension XCTestCase {
    
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated, Potential memory leak.", file: file, line: line)
        }
    }
}
