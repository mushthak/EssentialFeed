//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Mushthak Ebrahim on 07/11/22.
//

import Foundation

public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    
    public typealias SaveResult = Error?
    public typealias LoadResult = FeedResult

    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }

    public func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed{ [weak self] error in
            guard let self = self else { return }
            
            if let cacheDeletionError = error {
                completion(cacheDeletionError )
            } else {
                self.cache(feed, with: completion)
            }
        }
    }
    
    public func load( completion: @escaping (LoadResult) -> Void) {
        store.retrieve { error in
            if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    private func cache(_ feed:[FeedImage], with completion:@escaping (SaveResult ) -> Void) {
        store.insert(feed.toLocal(), timeStamp: self.currentDate()) { [weak self] error in
            guard self != nil else { return }
            
            completion(error)
        }
    }
}

private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        return map{ LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, imageURL: $0.url)}
    }
}
