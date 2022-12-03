//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Mushthak Ebrahim on 03/12/22.
//

import Foundation

public class CoreDataFeedStore: FeedStore {
    
    public init() {}
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
    
    public func insert(_ feed: [LocalFeedImage], timeStamp: Date, completion: @escaping InsertionCompletion) {
        
    }
    
    public func retrieve(completion: @escaping RetrivalCompletion) {
        completion(.empty)
    }

}
