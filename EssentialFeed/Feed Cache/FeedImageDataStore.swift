//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Mushthak Ebrahim on 25/06/23.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>
    
    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
