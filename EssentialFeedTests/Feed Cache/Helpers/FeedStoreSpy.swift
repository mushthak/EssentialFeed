//
//  FeedStoreSpy.swift
//  EssentialFeedTests
//
//  Created by Mushthak Ebrahim on 12/11/22.
//

import Foundation
import EssentialFeed

internal class FeedStoreSpy: FeedStore {
    
    enum ReceivedMessage: Equatable {
        case deleteCachedFeed
        case insert([LocalFeedImage],Date)
        case retrieve
    }
    
    var deletionCompletions = [DeletionCompletion]()
    var insertionCompletions = [InsertionCompletion]()
    var retrivalCompletions = [RetrivalCompletion]()
    
    private(set) var receivedMessages = [ReceivedMessage]()

    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        deletionCompletions.append(completion)
        receivedMessages.append(.deleteCachedFeed)
    }

    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }

    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }

    func insert(_ feeds: [LocalFeedImage], timeStamp: Date, completion: @escaping InsertionCompletion) {
        insertionCompletions.append(completion)
        receivedMessages.append(.insert(feeds, timeStamp))
    }
    
    func completeInsertion(with error:Error, at index: Int = 0) {
        insertionCompletions[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](nil)
    }
    
    func retrieve(completion: @escaping RetrivalCompletion) {
        retrivalCompletions.append(completion)
        receivedMessages.append(.retrieve)
    }
    
    func completeRetrieveal(with error:Error, at index: Int = 0) {
        retrivalCompletions[index](.failure(error))
    }
    
    func completeRetrievealWithEmptyCache(at index: Int = 0) {
        retrivalCompletions[index](.empty)
    }
    
    func completeRetrieveal(with feed: [LocalFeedImage], timestamp: Date , at index: Int = 0) {
        retrivalCompletions[index](.found(feeds: feed, timestamp: timestamp)) 
    }
    
}