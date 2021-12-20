//
//  AdsService.swift
//  ClassifiedAds
//
//  Created by Jeffrey Tabios on 12/20/21.
//

import Foundation
import RxSwift

protocol AdsServiceProtocol {
    func getAds() -> Observable<ClassifiedAds>
}

struct AdsService: APIService, AdsServiceProtocol {
    var useMock: Bool
    
    init(useMock: Bool = false) {
        self.useMock = useMock
    }
    
    func getAds() -> Observable<ClassifiedAds> {
        return request(url: AdsEndpoints.ads.endpoint, method: .GET, useMock: useMock)
    }
}
