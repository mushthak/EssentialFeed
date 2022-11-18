//
//  CodableFeedStoreTest.swift
//  EssentialFeedTests
//
//  Created by Mushthak Ebrahim on 16/11/22.
//

import XCTest
import EssentialFeed

class CodableFeedStoreTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }
    
    func test_retrive_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut: sut, toRetrieve: .empty)
    }
    
    func test_retrive_hasNoSideEfectsOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut: sut, toRetrieveTwice: .empty)
    }
    
    func test_retrive_deliversFoundValuesOnEmptyCache() {
        let sut = makeSUT()
        let feed = uniqueImageFeeds().local
        let timeStamp = Date()
        
        insert((feed: feed, timestamp: timeStamp), to: sut)
        
        self.expect(sut: sut, toRetrieve: .found(feeds: feed, timestamp: timeStamp))
    }
    
    func test_retrive_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        let feed = uniqueImageFeeds().local
        let timeStamp = Date()
        
        insert((feed: feed, timestamp: timeStamp), to: sut)
        
        self.expect(sut: sut, toRetrieveTwice: .found(feeds: feed, timestamp: timeStamp))
    }
    
    func test_retrieve_failureOnRetrievalError() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try! "Invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        self.expect(sut: sut, toRetrieve: .failure(anyNSError()))
    }
    
    func test_retrieve_hasNoSideEffectsOnFailure() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try! "Invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        self.expect(sut: sut, toRetrieveTwice: .failure(anyNSError()))
    }
    
    func test_insert_overridesPreviouslyInsertedValues() {
        let sut = makeSUT()
        let feed = uniqueImageFeeds().local
        
        let timeStamp = Date()
        let firstInsertionError = insert((feed: feed, timestamp: timeStamp), to: sut)
        XCTAssertNil(firstInsertionError,"Expected to insert cache successfully")
        
        let latestFeed = uniqueImageFeeds().local
        let latestTimeStamp = Date()
        let latestInsertionError = insert((feed: latestFeed, timestamp: latestTimeStamp), to: sut)
        
        XCTAssertNil(latestInsertionError,"Expected to replace cache successfully")
        self.expect(sut: sut, toRetrieve: .found(feeds: latestFeed, timestamp: latestTimeStamp))
    }
    
    func test_insert_deliversErrorOnInsertionError() {
        let invalidStoreURL = URL(string: "invalid://store.url")
        let sut = makeSUT(storeURL: invalidStoreURL)
        
        let feed = uniqueImageFeeds().local
        let insertionError = insert((feed: feed, timestamp: Date()), to: sut)
        
        XCTAssertNotNil(insertionError, "Expected cache insertion fail with an error")
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        let deletionError = deleteCache(from: sut)
        XCTAssertNil(deletionError, "Expected empty cache deletion to be success")
        
        expect(sut: sut, toRetrieve: .empty)
    }
    
    func test_delete_emptyPreviouslyInsertedCache() {
        let sut = makeSUT()
        let feed = uniqueImageFeeds().local
        let timeStamp = Date()
        
        insert((feed: feed, timestamp: timeStamp), to: sut)
        let deletionError = deleteCache(from: sut)
        XCTAssertNil(deletionError, "Expected non-empty cache deletion to be success")
        
        expect(sut: sut, toRetrieve: .empty)
    }
    
    func test_delete_deliverErrorOnDeletionError() {
        let noDeletePermissionURL = cacheDirectory()
        let sut = makeSUT(storeURL: noDeletePermissionURL)
        
        let deleteError = deleteCache(from: sut)
        
        XCTAssertNotNil(deleteError, "Expect cache deletion to fail")
        expect(sut: sut, toRetrieve: .empty)
    }
    
    func test_storeSideEffects_runSerially() {
        let sut = makeSUT()
        var completedOperationsInOrder = [XCTestExpectation]()
        
        let op1 = expectation(description: "Operation 1")
        sut.insert(uniqueImageFeeds().local, timeStamp: Date()) { _ in
            completedOperationsInOrder.append(op1)
            op1.fulfill()
        }
        let op2 = expectation(description: "Operation 2")
        sut.deleteCachedFeed { _ in
            completedOperationsInOrder.append(op2)
            op2.fulfill()
        }
        let op3 = expectation(description: "Operation 3")
        sut.insert(uniqueImageFeeds().local, timeStamp: Date()) { _ in
            completedOperationsInOrder.append(op3)
            op3.fulfill()
        }
        waitForExpectations(timeout: 5.0)
        
        XCTAssertEqual(completedOperationsInOrder, [op1, op2, op3], "Expected side-effects to run serially but operations finished in the wrong order")
    }
    
    // MARK: - Helpers

    private func  makeSUT(storeURL: URL? = nil,file: StaticString = #file, line: UInt = #line) -> FeedStore {
        let sut = CodableFeedStore(storeURL: storeURL ?? testSpecificStoreURL())
        trackForMemoryLeak(sut)
        return sut
    }
    
    @discardableResult
    private func insert(_ cache: (feed: [LocalFeedImage], timestamp: Date), to sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for cache retrieval")
        var insertionError: Error?
        sut.insert(cache.feed, timeStamp: cache.timestamp) { receivedInsertionError in
            insertionError = receivedInsertionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return insertionError
    }
    
    private func deleteCache(from sut: FeedStore,file: StaticString = #file, line: UInt = #line) -> Error? {
        let exp = expectation(description: "Wait for cache deletion")
        var deletionError: Error?
        sut.deleteCachedFeed { receivedDeletionError in
            deletionError = receivedDeletionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return deletionError
    }
    
    private func expect(sut: FeedStore, toRetrieveTwice expectedResult: RetriveCachedFeedResult, file: StaticString = #file, line: UInt = #line) {
        expect(sut: sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut: sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    private func expect(sut: FeedStore, toRetrieve expectedResult: RetriveCachedFeedResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")
        sut.retrieve { retrivedResult in
            switch (expectedResult, retrivedResult) {
            case (.empty, .empty),
                (.failure,.failure):
                break
            case let (.found(expectedFound), .found(receivedFound)):
                XCTAssertEqual(receivedFound.feeds, expectedFound.feeds, file: file, line: line)
                XCTAssertEqual(receivedFound.timestamp, expectedFound.timestamp, file: file, line: line)
            default:
                XCTFail("Expected to retrive \(expectedResult), got \(retrivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func testSpecificStoreURL() -> URL {
        return cacheDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    
    private func cacheDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
