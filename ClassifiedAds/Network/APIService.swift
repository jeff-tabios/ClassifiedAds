//
//  APIService.swift
//  ClassifiedAds
//
//  Created by Jeffrey Tabios on 12/20/21.
//

import Foundation
import RxSwift

public enum APIServiceError: Error {
    case none
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case decodeError
    case fileNotFound
}

protocol APIService {
    func request<T: Codable>(url: String, method: HTTPMethod, contentType: String, params: [String: Any]?, useMock: Bool) -> Observable<T>
}

extension APIService {
    func request<T: Codable>(url: String,
                              method: HTTPMethod,
                              contentType: String = "application/json",
                              params: [String: Any]? = nil,
                              useMock: Bool = false) -> Observable<T> {
        
        return Observable<T>.create({ (observer) -> Disposable in
            
            if let apiEndpoint = URL(string: url) {
                var urlRequest = URLRequest(url: apiEndpoint)
                urlRequest.httpMethod = method.rawValue
                urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
                
                let configuration = URLSessionConfiguration.default
                if useMock {
                    configuration.protocolClasses = [MockURLProtocol.self]
                }
                let sessionManager = URLSession(configuration: configuration)
                
                sessionManager.dataTask(with: urlRequest) { data, response, error in
                    if let data = data {
                        
                        let decoder = JSONDecoder()
                        guard let result = try? decoder.decode(T.self, from: data) else {
                            observer.onError(APIServiceError.decodeError)
                            return
                        }
                        observer.onNext(result)
                        
                    } else if let error = error {
                        observer.onError(error)
                    }
                    
                }.resume()
            } else {
                observer.onError(APIServiceError.apiError)
            }
            
            return Disposables.create()
        })

    }
}
