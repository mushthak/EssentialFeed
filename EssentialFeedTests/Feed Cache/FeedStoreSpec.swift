//
//  FeedStoreSpec.swift
//  EssentialFeedTests
//
//  Created by Mushthak Ebrahim on 23/11/22.
//

import Foundation

protocol FeedStoreSpec {
    func test_retrive_deliversEmptyOnEmptyCache()
    func test_retrive_hasNoSideEfectsOnEmptyCache()
    func test_retrive_deliversFoundValuesOnEmptyCache()
    func test_retrive_hasNoSideEffectsOnNonEmptyCache()
    
    func test_insert_overridesPreviouslyInsertedValues()
    
    func test_delete_hasNoSideEffectsOnEmptyCache()
    func test_delete_emptyPreviouslyInsertedCache()
    
    func test_storeSideEffects_runSerially()
}

protocol FailableRetrieveFeedStoreSpec: FeedStoreSpec {
    func test_retrieve_failureOnRetrievalError()
    func test_retrieve_hasNoSideEffectsOnFailure()
}

protocol FailableInsertFeedStoreSpec: FeedStoreSpec {
    func test_insert_deliversErrorOnInsertionError()
    func test_insert_hasNoSideEffectOnInsertionError()
}

protocol FailableDeleteFeesStoreSpec: FeedStoreSpec {
    func test_delete_deliverErrorOnDeletionError()
    func test_delete_hasNoSideEffectOnDeletionError()
}

typealias FailableFeedStoreSpec = FailableRetrieveFeedStoreSpec & FailableInsertFeedStoreSpec & FailableDeleteFeesStoreSpec