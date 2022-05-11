//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Mushthak Ibrahim on 5/10/22.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion: (Error) -> Void)
}

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
    }

    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }

    public func load(completion: (Error) -> Void = {_ in}) {
        client.get(from: url) { error in
            completion(.connectivity)
        }
    }
}
