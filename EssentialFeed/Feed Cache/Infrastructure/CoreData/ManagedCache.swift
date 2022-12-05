//
//  ManagedCache.swift
//  EssentialFeed
//
//  Created by Mushthak Ebrahim on 04/12/22.
//

import CoreData

@objc(ManagedCache)
internal class ManagedCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var feed: NSOrderedSet
}

extension ManagedCache {
    internal static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
        let request = NSFetchRequest<ManagedCache>(entityName: ManagedCache.entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    internal static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedCache {
        try find(in: context).map(context.delete)
        return ManagedCache(context: context)
    }
    
    internal var localFeed: [LocalFeedImage] {
        return feed.compactMap { ($0 as? ManagedFeedImage)?.local }
    }
}
