//
//  FeedCacheTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Mushthak Ebrahim on 14/11/22.
//

import Foundation
import EssentialFeed

func uniqueImageFeeds() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let items = [uniqueImage(), uniqueImage()]
    let localItems = items.map{LocalFeedImage.init(id: $0.id, description: $0.description, location: $0.location, imageURL: $0.url)}
    return (items,localItems)
}

func uniqueImage() -> FeedImage {
    return FeedImage.init(id: UUID.init(), description: "any", location: "any", url: anyURL())
}

extension Date {
    func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
    
    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -7)
    }
}

