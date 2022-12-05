//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Mushthak Ebrahim on 12/11/22.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}
