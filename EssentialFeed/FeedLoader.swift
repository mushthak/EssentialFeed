//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Mushthak Ibrahim on 4/25/22.
//

import Foundation

enum FeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (FeedResult) -> Void)
}
