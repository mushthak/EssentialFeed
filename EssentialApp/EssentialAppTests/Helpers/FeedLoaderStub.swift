//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Mushthak Ebrahim on 05/07/23.
//

import EssentialFeed

class FeedLoaderStub: FeedLoader {
    private let result: FeedLoader.Result
    
    init(result: FeedLoader.Result) {
        self.result = result
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }
}
