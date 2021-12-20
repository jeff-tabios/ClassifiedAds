//
//  MockURLProtocol.swift
//  ClassifiedAds
//
//  Created by Jeffrey Tabios on 12/20/21.
//

import Foundation

final class MockURLProtocol: URLProtocol {
    private let cannedHeaders = ["Content-Type" : "application/json; charset=utf-8"]
    
    enum ResponseType {
        case error(Error)
        case success(HTTPURLResponse)
    }
    static var responseType: ResponseType!
    
    private lazy var session: URLSession = {
        let configuration: URLSessionConfiguration = URLSessionConfiguration.ephemeral
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    private(set) var activeTask: URLSessionTask?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }
    
    func getJsonDataFromFile(filename: String) -> Data? {
        var json: Data?
                
        if let path = Bundle(for: type(of: self)).path(forResource: filename, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                json = data
            } catch {
                // handle error
            }
        }
        
        return json
    }
    
    override func startLoading() {
        
        let filename = "mock_" + (request.url?.lastPathComponent ?? "") + "_" + (request.httpMethod ?? "")
        
        if let data = getJsonDataFromFile(filename: filename),
            let url = request.url,
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: cannedHeaders) {
            
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: URLCache.StoragePolicy.notAllowed)
            
            client?.urlProtocol(self, didLoad: data)
            
        } else {
            print("\n========\nTest json not found: " + filename + "\n========\n")
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        activeTask?.cancel()
    }
}

// MARK: - URLSessionDataDelegate
extension MockURLProtocol: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        client?.urlProtocol(self, didLoad: data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        switch MockURLProtocol.responseType {
        case .error(let error)?:
            client?.urlProtocol(self, didFailWithError: error)
        case .success(let response)?:
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        default:
            break
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
}

extension MockURLProtocol {
    
    enum MockError: Error {
        case none
    }
    
    static func responseWithFailure() {
        MockURLProtocol.responseType = MockURLProtocol.ResponseType.error(MockError.none)
    }
    
    static func responseWithStatusCode(code: Int) {
        MockURLProtocol.responseType = MockURLProtocol.ResponseType.success(HTTPURLResponse(url: URL(string: "http://any.com")!, statusCode: code, httpVersion: nil, headerFields: nil)!)
    }
}
