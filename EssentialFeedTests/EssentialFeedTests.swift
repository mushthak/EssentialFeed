//
//  EssentialFeedTests.swift
//  EssentialFeedTests
//
//  Created by Mushthak Ibrahim on 4/25/22.
//

import XCTest
import EssentialFeed

class EssentialFeedTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_load_requestsDataFromUrl() {
        let url = URL(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load()

        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_loadTwice_requestsDataFromUrlTwice() {
        let url = URL(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load()
        sut.load()

        XCTAssertEqual(client.requestedURLs, [url,url])
    }

    //MARK: - Helpers

    private func makeSUT(url: URL = URL(string: "http://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url,client: client)
        return (sut,client)
    }

    private class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
        var requestedURLs = [URL]()

        func get(from url: URL) {
            requestedURL = url
            requestedURLs.append(url)
        }
    }
}
