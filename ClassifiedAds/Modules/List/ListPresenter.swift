//
//  ListPresenter.swift
//  ClassifiedAds
//
//  Created by Jeffrey Tabios on 12/20/21.
//

import Foundation
import RxSwift
import RxCocoa

final class ListPresenter {
    let disposeBag = DisposeBag()
    weak var view: ListView?
    var router: ListRouter?
    var interactor: ListInteractor?
    
    let ads = PublishSubject<ClassifiedAds>()
    
    let viewLoadedTrigger = PublishSubject<Void>()
    
    init(interactor: ListInteractor, router: ListRouter? = nil) {
        self.interactor = interactor
        self.router = router
        
        viewLoadedTrigger.asObservable()
            .bind(to: interactor.getContentTrigger)
            .disposed(by: disposeBag)
        
        interactor.ads.asObservable()
            .bind(to: ads)
            .disposed(by: disposeBag)
        
    }
}
