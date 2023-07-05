//
//  InMemoryFeedStore.swift
//  EssentialAppTests
//
//  Created by Mushthak Ebrahim on 05/07/23.
//

import Foundation
import EssentialFeed

class InMemoryFeedStore {
    private(set) var feedCache: CachedFeed?
    private var feedImageDataCache: [URL: Data] = [:]
    
    private init(feedCache: CachedFeed? = nil) {
        self.feedCache = feedCache
    }
}

extension InMemoryFeedStore: FeedStore {
    func deleteCachedFeed(completion: @escaping FeedStore.DeletionCompletion) {
        feedCache = nil
        completion(.success(()))
    }
    
    func insert(_ feed: [LocalFeedImage], timeStamp: Date, completion: @escaping FeedStore.InsertionCompletion) {
        feedCache = CachedFeed(feeds: feed, timestamp: timeStamp)
        completion(.success(()))
    }
    
    func retrieve(completion: @escaping FeedStore.RetrivalCompletion) {
        completion(.success(feedCache))
    }
}

extension InMemoryFeedStore: FeedImageDataStore {
    func insert(_ data: Data, for url: URL, completion: @escaping (FeedImageDataStore.InsertionResult) -> Void) {
        feedImageDataCache[url] = data
        completion(.success(()))
    }
    
    func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
        completion(.success(feedImageDataCache[url]))
    }
}

extension InMemoryFeedStore {
    static var empty: InMemoryFeedStore {
        InMemoryFeedStore()
    }
    
    static var withExpiredFeedCache: InMemoryFeedStore {
        InMemoryFeedStore(feedCache: CachedFeed(feeds: [], timestamp: Date.distantPast))
    }
    
    static var withNonExpiredFeedCache: InMemoryFeedStore {
        InMemoryFeedStore(feedCache: CachedFeed(feeds: [], timestamp: Date()))
    }
}
