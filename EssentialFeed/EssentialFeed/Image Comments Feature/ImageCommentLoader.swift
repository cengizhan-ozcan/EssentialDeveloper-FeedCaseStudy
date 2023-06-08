//
//  ImageCommentLoader.swift
//  EssentialFeed
//
//  Created by Cengizhan Özcan on 7.06.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation

public protocol ImageCommentLoader {
    typealias Result = Swift.Result<[ImageComment], Error>
    
    func load(completion: @escaping (Result) -> Void) -> LoaderTask
}
