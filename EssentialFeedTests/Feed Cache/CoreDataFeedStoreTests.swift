//
//  CoreDataFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Mushthak Ebrahim on 03/12/22.
//

import XCTest
import EssentialFeed

class CoreDataFeedStoreTests: XCTestCase, FailableFeedStoreSpec {
    
    func test_retrieve_failureOnRetrievalError() {
        
    }
    
    func test_retrieve_hasNoSideEffectsOnFailure() {
        
    }
    
    func test_insert_deliversNoErrorOnEmptyCache() {
        let sut = makeSUT()
        
        assertThatInsertDeliversNoErrorOnEmptyCache(on: sut)
    }
    
    func test_insert_deliversNoErrorOnNonEmptyCache() {
        let sut = makeSUT()
        
        assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut)
    }
    
    func test_insert_deliversErrorOnInsertionError() {
        
    }
    
    func test_insert_hasNoSideEffectOnInsertionError() {
        
    }
    
    func test_delete_deliverErrorOnDeletionError() {
        
    }
    
    func test_delete_hasNoSideEffectOnDeletionError() {
        
    }
    
    func test_retrive_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        
        assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
    }
    
    func test_retrive_hasNoSideEfectsOnEmptyCache() {
        let sut = makeSUT()
        
        assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
    }
    
    func test_retrive_deliversFoundValuesOnNonEmptyCache() {
        let sut = makeSUT()
        
        assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on: sut)
    }
    
    func test_retrive_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        
        assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on: sut)
    }
    
    func test_insert_overridesPreviouslyInsertedValues() {
        let sut = makeSUT()
        
        assertThatInsertOverridesPreviouslyInsertedCacheValues(on: sut)
    }
    
    func test_delete_deliversNoErrorOnEmptyCache() {
        let sut = makeSUT()
        
        assertThatDeleteDeliversNoErrorOnEmptyCache(on: sut)
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        assertThatDeleteHasNoSideEffectsOnEmptyCache(on: sut)
    }
    
    func test_delete_emptyPreviouslyInsertedCache() {
        
    }
    
    func test_storeSideEffects_runSerially() {
        
    }
    
    // MARK: - Helpers

    private func  makeSUT(storeURL: URL? = nil,file: StaticString = #file, line: UInt = #line) -> FeedStore {
        let storeBundle = Bundle(for: CoreDataFeedStore.self)
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataFeedStore(storeURL: storeURL, bundle: storeBundle)
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
    
}

