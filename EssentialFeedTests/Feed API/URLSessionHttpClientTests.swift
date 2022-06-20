//
//  URLSessionHttpClientTests.swift
//  EssentialFeedTests
//
//  Created by Mushthak Ibrahim on 6/20/22.
//

import Foundation
import XCTest
import EssentialFeed

class URLSessionHTTPClient {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func get(from url: URL,completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }

}

class URLSessionHttpClientTests: XCTestCase {

    func test_getFromURL_failsOnRequestError() {
        URLProtocolStub.startInterceptingRequests()
        let url = URL(string: "http://any-url.com")!
        let error = NSError(domain: "any error", code: 1)
        URLProtocolStub.stub(url: url, error: error)

        let sut = URLSessionHTTPClient()

        let exp = expectation(description: "Wait for completion")

        sut.get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError.domain, error.domain)
                XCTAssertEqual(receivedError.code, error.code)
            default:
                XCTFail("Expected failure with \(error) with got \(result) instead")
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
        URLProtocolStub.stopInterceptingRequests()
    }

    //MARK: - Helpers

    private class URLProtocolStub: URLProtocol {
        private static var stubs = [URL: Stub]()

        private struct Stub {
            let error: Error?
        }

        static func stub(url: URL, error: Error? = nil) {
            stubs[url] = Stub(error: error)
        }

        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }

        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stubs = [:]
        }

        override class func canInit(with request: URLRequest) -> Bool {
            guard let url = request.url else { return false}

            return URLProtocolStub.stubs[url] != nil
        }

        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }

        override func startLoading() {
            guard let url = request.url, let stub = URLProtocolStub.stubs[url] else { return }

            if let error = stub.error {
                client?.urlProtocol(self, didFailWithError: error)
            }

            client?.urlProtocolDidFinishLoading(self)
        }

        override func stopLoading() {}

    }

}
