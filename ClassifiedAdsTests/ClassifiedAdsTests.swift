//
//  ClassifiedAdsTests.swift
//  ClassifiedAdsTests
//
//  Created by Jeffrey Tabios on 12/20/21.
//

import XCTest
import RxSwift
import UIKit
import CachedImage
@testable import ClassifiedAds

class ClassifiedAdsTests: XCTestCase {
    
    //===============================================================
    //Sample Unit Tests
    //===============================================================
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
    
    //===============================================================
    //Sample Integration Tests for Async Cached Image Framework
    //===============================================================
    func test_cellShouldLoadAnImage() {
        
        //Remove any existing image
        let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                        in: .userDomainMask)[0]
        let imageFileName = documentDirectory.appendingPathComponent("testImg.png")
        if FileManager.default.fileExists(atPath: imageFileName.path) {
            try? FileManager.default.removeItem(at: imageFileName)
        }
        
        let image = AsyncCachedImage()
        if let imgPath = Bundle(for: type(of: self)).path(forResource: "test", ofType: "png") {
            let url = URL(fileURLWithPath: imgPath)
            let exp = expectation(description: "get image")
            image.loadImage(from: url, cacheId: "testImg") { result in
                XCTAssert(result == .downloaded)
                exp.fulfill()
            }
            wait(for: [exp], timeout: 10)
        }
    }
    
    func test_cellShouldLoadAnImageFromCache() {
        
        //Remove any existing image
        let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                        in: .userDomainMask)[0]
        let imageFileName = documentDirectory.appendingPathComponent("testImg.png")
        if FileManager.default.fileExists(atPath: imageFileName.path) {
            try? FileManager.default.removeItem(at: imageFileName)
        }
        
        let image = AsyncCachedImage()
        if let imgPath = Bundle(for: type(of: self)).path(forResource: "test", ofType: "png") {
            let url = URL(fileURLWithPath: imgPath)
            let exp = expectation(description: "get image")
            
            let semaphore = DispatchSemaphore(value: 1) // 1 at a time
            
            semaphore.wait()
            image.loadImage(from: url, cacheId: "testImg") { result in
                semaphore.signal()
            }
            
            semaphore.wait()
            image.loadImage(from: url, cacheId: "testImg") { result in
                XCTAssert(result == .cache)
                exp.fulfill()
                semaphore.signal()
            }
            
            wait(for: [exp], timeout: 10)
        }
    }
    
}
