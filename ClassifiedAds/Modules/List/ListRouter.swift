//
//  ListRouter.swift
//  ClassifiedAds
//
//  Created by Jeffrey Tabios on 12/20/21.
//

import Foundation
import UIKit

class ListRouter {
    var view: ListView {
        let vc = ListView()
        
        let adsService = AdsService()
        
        let interactor = ListInteractor(adsService: adsService)
        let presenter = ListPresenter(interactor: interactor, router: self)
        presenter.view = vc
        
        vc.presenter = presenter
        return vc
    }
    
    func showDetail(from: ListView, ad: Ad) {
        let detailRouter = DetailRouter(ad: ad)
        from.navigationController?.pushViewController(detailRouter.view, animated: true)
    }
}
