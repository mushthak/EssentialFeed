//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Mushthak Ibrahim on 4/25/22.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage],Error>
    
    func load(completion: @escaping (Result) -> Void)
}
