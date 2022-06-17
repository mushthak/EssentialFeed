//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Mushthak Ibrahim on 6/17/22.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL,
             completion:@escaping (HTTPClientResult) -> Void)
}
