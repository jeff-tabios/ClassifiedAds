//
//  ClassifiedAdsTests.swift
//  ClassifiedAdsTests
//
//  Created by Jeffrey Tabios on 12/20/21.
//

import XCTest
import RxSwift
@testable import ClassifiedAds

class ClassifiedAdsTests: XCTestCase {
    
    //Test ads service using mock json
    func test_adsServiceShouldReturnResult() {

        let sut = AdsService(useMock: true)
        let bag = DisposeBag()
        
        let exp = expectation(description: "get ads")
        
        sut.getAds()
            .asObservable()
            .subscribe(onNext: { ads in
                XCTAssert(ads.results?.count == 1)
                exp.fulfill()
            }).disposed(by: bag)
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_getContentInteractorShouldReturnContent() {
        let sut = ListInteractor(adsService: AdsService(useMock: true))
        let bag = DisposeBag()
        
        let exp = expectation(description: "get content")
        
        sut.ads.asObservable()
            .subscribe(onNext: { ads in
                XCTAssert(ads.results?.count == 1)
                exp.fulfill()
            }).disposed(by: bag)
        
        
        sut.getContentTrigger.onNext(())
        wait(for: [exp], timeout: 10)
    }

}
