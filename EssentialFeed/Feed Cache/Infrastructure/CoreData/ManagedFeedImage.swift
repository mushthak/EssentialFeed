//
//  ManagedFeedImage.swift
//  EssentialFeed
//
//  Created by Mushthak Ebrahim on 04/12/22.
//

import CoreData

@objc(ManagedFeedImage)
internal class ManagedFeedImage: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var imageDescription: String?
    @NSManaged var location: String?
    @NSManaged var url: URL
    @NSManaged var cache: ManagedCache
}

extension ManagedFeedImage {
    internal static func images(from localFeeds: [LocalFeedImage], in context:NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: localFeeds.map { local in
            let managedFeed = ManagedFeedImage(context: context)
            managedFeed.id = local.id
            managedFeed.imageDescription = local.description
            managedFeed.location = local.location
            managedFeed.url = local.url
            return managedFeed
        })
    }
    
    internal var local: LocalFeedImage {
        return LocalFeedImage(id: id, description: imageDescription, location: location, imageURL: url)
    }
}
