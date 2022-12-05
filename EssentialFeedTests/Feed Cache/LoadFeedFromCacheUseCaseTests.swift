//
//  LoadFeedFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Mushthak Ebrahim on 12/11/22.
//

import XCTest
import EssentialFeed

final class LoadFeedFromCacheUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestsCacheRetrival() {
        let (sut, store) = makeSUT()
        
        sut.load() {_ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve] )
    }
    
    func test_load_failsOnRetrivalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(retrievalError)) {
            store.completeRetrieveal(with: retrievalError)
        }
    }
    
    func test_load_deliverNoImagesOnEmptyCache() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWith: .success([])) {
            store.completeRetrievealWithEmptyCache()
        }
        
    }
    
    func test_load_deliversCachedImagesOnNonExpiredCache() {
        let feeds = uniqueImageFeeds()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        expect(sut, toCompleteWith: .success(feeds.models)) {
            store.completeRetrieveal(with: feeds.local, timestamp: nonExpiredTimestamp)
        }
    }
    
    func test_load_deliversNoImagesOnCacheExpiration() {
        let feeds = uniqueImageFeeds()
        let fixedCurrentDate = Date()
        let expirationTimestamp = fixedCurrentDate.minusFeedCacheMaxAge()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        expect(sut, toCompleteWith: .success([])) {
            store.completeRetrieveal(with: feeds.local, timestamp: expirationTimestamp)
        }
    }
    
    func test_load_deliversNoImagesOnExpiredCache() {
        let feeds = uniqueImageFeeds()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        expect(sut, toCompleteWith: .success([])) {
            store.completeRetrieveal(with: feeds.local, timestamp: expiredTimestamp)
        }
    }
    
    func test_load_hadNoSideEffectsOnRetrievalError() {
        let (sut, store) = makeSUT()
        sut.load { _ in }
        
        store.completeRetrieveal(with: anyNSError())
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hadNoSideEffectsOnEmptyCache() {
        let (sut, store) = makeSUT()
        sut.load { _ in }
        
        store.completeRetrievealWithEmptyCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnNonExpiredCache() {
        let feeds = uniqueImageFeeds()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        sut.load { _ in }
        store.completeRetrieveal(with: feeds.local, timestamp: nonExpiredTimestamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnCacheExpiration() {
        let feeds = uniqueImageFeeds()
        let fixedCurrentDate = Date()
        let expirationTimestamp = fixedCurrentDate.minusFeedCacheMaxAge()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        sut.load { _ in }
        store.completeRetrieveal(with: feeds.local, timestamp: expirationTimestamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnExpiredCache() {
        let feeds = uniqueImageFeeds()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        sut.load { _ in }
        store.completeRetrieveal(with: feeds.local, timestamp: expiredTimestamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_doesNotDeliverResultAfterSutInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
        
        var receivedResult = [LocalFeedLoader.LoadResult]()
        sut?.load { receivedResult.append($0) }
        
        sut = nil
        store.completeRetrievealWithEmptyCache()
        
        XCTAssertTrue(receivedResult.isEmpty)
    }
    
     
    // MARK: - Helpers

    private func  makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeak(store, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalFeedLoader, toCompleteWith expectedResult: LocalFeedLoader.LoadResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedImages),.success(expectedImages)):
                XCTAssertEqual(receivedImages, expectedImages, file: file, line: line)
            case let (.failure(receivedError),.failure(expectedError)):
                XCTAssertEqual(receivedError as NSError, expectedError as NSError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line )
            }
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
}
