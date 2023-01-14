//
//  URLSessionHTTPClient.swift
//  EssentialFeed
//
//  Created by Cengizhan Özcan on 16.12.2022.
//  Copyright © 2022 Essential Developer. All rights reserved.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
        
    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else {
                completion(.failure(UnexpectedValuesRepresentation()))
            }
        }.resume()
    }
}
