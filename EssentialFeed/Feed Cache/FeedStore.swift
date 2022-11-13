//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Mushthak Ebrahim on 07/11/22.
//

import Foundation

public enum RetriveCachedFeedResult {
    case empty
    case found(feeds: [LocalFeedImage], timestamp: Date)
    case failure(Error)
}

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrivalCompletion = (RetriveCachedFeedResult) -> Void
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func insert(_ feed: [LocalFeedImage], timeStamp: Date, completion: @escaping InsertionCompletion)
    func retrieve(completion: @escaping RetrivalCompletion)
}
