//
//  FeedImageDataLoader.swift
//  EssentialFeediOS
//
//  Created by Mushthak Ebrahim on 04/06/23.
//

import Foundation

public protocol FeedImageDataLoaderTask {
    func cancel()
}

public protocol FeedImageDataLoader {
    typealias Result = Swift.Result<Data, Error>

    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
}
