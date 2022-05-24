//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Mushthak Ibrahim on 4/25/22.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
