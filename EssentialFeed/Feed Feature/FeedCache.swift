//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Mushthak Ebrahim on 05/07/23.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>
    
    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
