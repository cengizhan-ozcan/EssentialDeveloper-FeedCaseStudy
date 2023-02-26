//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Cengizhan Özcan on 26.02.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import CoreData

public final class CoreDataFeedStore {
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(modelName: "FeedStore", url: storeURL, in: bundle)
        context = container.newBackgroundContext()
    }
    
    func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
}
