//
//  ListInteractor.swift
//  ClassifiedAds
//
//  Created by Jeffrey Tabios on 12/20/21.
//

import Foundation
import RxSwift
import RxCocoa

final class ListInteractor {
    let disposeBag = DisposeBag()
    var adsService: AdsServiceProtocol
    
    let ads = PublishSubject<ClassifiedAds>()
    var getContentTrigger = PublishSubject<Void>()
    
    init(adsService: AdsServiceProtocol) {
        self.adsService = adsService
        
        getContentTrigger
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.getAds()
            })
            .disposed(by: disposeBag)
    }
    
    func getAds() {
       adsService.getAds()
        .subscribe(onNext: { [weak self] ads in
            self?.ads.onNext(ads)
        }).disposed(by: disposeBag)
    }
}
