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

        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_loadTwice_requestsDataFromUrlTwice() {
        let url = URL(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url,url])
    }

    func test_load_deliverErrorOnClientError() {
        let (sut, client) = makeSUT()

        var capturedError = [RemoteFeedLoader.Error]()
        sut.load { capturedError.append($0) }
        let clientError = NSError.init(domain: "Test", code: 0)
        client.complete(with: clientError)

        XCTAssertEqual(capturedError, [.connectivity])
    }

    func test_load_deliverErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            var capturedError = [RemoteFeedLoader.Error]()
            sut.load { capturedError.append($0) }

            client.complete(withStatusCode: code,index: index)

            XCTAssertEqual(capturedError, [.invalidData])
        }

    }


    //MARK: - Helpers

    private func makeSUT(url: URL = URL(string: "http://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url,client: client)
        return (sut,client)
    }

    private class HTTPClientSpy: HTTPClient {
        var messages = [(url: URL, completion: (Error?, HTTPURLResponse?) -> Void)]()

        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }

        func get(from url: URL, completion:@escaping (Error? , HTTPURLResponse?) -> Void) {
            messages.append((url,completion))
        }

        func complete(with error: Error, index: Int = 0) {
            messages[index].completion(error, nil)
        }

        func complete(withStatusCode code: Int, index: Int = 0) {
            let response = HTTPURLResponse(url: messages[index].url,
                                                    statusCode: code,
                                                    httpVersion: nil,
                                                    headerFields: nil)
            messages[index].completion(nil, response)
        }
    }
}
