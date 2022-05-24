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

        expect(sut, toCompleWithError: .connectivity, when: {
            let clientError = NSError.init(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }

    func test_load_deliverErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleWithError: .invalidData, when: {
                client.complete(withStatusCode: code,index: index)
            })
        }

    }

    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleWithError: .invalidData, when: {
            let invalidJSON = Data(_: "invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }

    func test_deliverNoItemson200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()

        var capturedResults = [RemoteFeedLoader.Result]()
        sut.load { capturedResults.append($0) }

        let emptyListJSON = Data(_: "{\"items\":[]}".utf8)
        client.complete(withStatusCode: 200, data: emptyListJSON)

        XCTAssertEqual(capturedResults, [.success([])])
    }


    //MARK: - Helpers

    private func makeSUT(url: URL = URL(string: "http://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url,client: client)
        return (sut,client)
    }

    private func expect(_ sut: RemoteFeedLoader, toCompleWithError error: RemoteFeedLoader.Error, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var capturedResults = [RemoteFeedLoader.Result]()
        sut.load { capturedResults.append($0) }

        action()

        XCTAssertEqual(capturedResults, [.failure(error)], file: file, line: line)
    }

    private class HTTPClientSpy: HTTPClient {
        var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()

        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }

        func get(from url: URL, completion:@escaping (HTTPClientResult) -> Void) {
            messages.append((url,completion))
        }

        func complete(with error: Error, index: Int = 0) {
            messages[index].completion(.failure(error))
        }

        func complete(withStatusCode code: Int,
                      data: Data = Data(),
                      index: Int = 0) {
            let response = HTTPURLResponse(url: messages[index].url,
                                           statusCode: code,
                                           httpVersion: nil,
                                           headerFields: nil)!
            messages[index].completion(.success(data, response))
        }
    }
}
