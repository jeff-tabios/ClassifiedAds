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
    
    init(interactor: ListInteractor, router: ListRouter) {
        self.interactor = interactor
        self.router = router

//        cartButtonTappedTrigger.asDriver(onErrorDriveWith: .empty())
//            .drive(onNext: { [weak self] _ in
//                if let view = self?.view {
//                    self?.router?.showCart(from: view)
//                }
//            })
//            .disposed(by: disposeBag)
        
        viewLoadedTrigger.asObservable()
            .bind(to: interactor.getContentTrigger)
            .disposed(by: disposeBag)
        
        interactor.ads.asObservable()
            .bind(to: ads)
            .disposed(by: disposeBag)
        
    }
}