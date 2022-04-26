//
//  EssentialFeedTests.swift
//  EssentialFeedTests
//
//  Created by Mushthak Ibrahim on 4/25/22.
//

import XCTest
@testable import EssentialFeed

class RemoteFeedLoader {
    let client: HTTPClient
    let url: URL

    init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }

    func load() {
        client.get(from: url)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?

    func get(from url: URL) {
        requestedURL = url
    }
}

class EssentialFeedTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        let url = URL(string: "http://a-url.com")!
        _ = RemoteFeedLoader(url: url,client: client)
        XCTAssertNil(client.requestedURL)
    }

    func test_load_requestDataFromUrl() {
        let url = URL(string: "http://a-given-url.com")!
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url,client: client)

        sut.load()

        XCTAssertEqual(client.requestedURL, url)
    }
}
