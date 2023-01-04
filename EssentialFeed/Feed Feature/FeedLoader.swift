//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Mushthak Ibrahim on 4/25/22.
//

import Foundation

public typealias FeedResult = Result<[FeedImage],Error>

public protocol FeedLoader {
    func load(completion: @escaping (FeedResult) -> Void)
}
