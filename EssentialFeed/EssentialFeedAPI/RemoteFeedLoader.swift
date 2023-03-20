//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation
import EssentialFeed
import SharedAPI

public typealias RemoteFeedLoader = RemoteLoader<[FeedImage]>

public extension RemoteFeedLoader {
    
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: FeedItemsMapper.map)
    }
}
