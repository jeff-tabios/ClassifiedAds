//
//  ListRouter.swift
//  ClassifiedAds
//
//  Created by Jeffrey Tabios on 12/20/21.
//

import Foundation
import UIKit

class ListRouter {
    var view: UIViewController {
        let vc = ListView()
        
        let adsService = AdsService(useMock: true)
        
        let interactor = ListInteractor(adsService: adsService)
        let presenter = ListPresenter(interactor: interactor, router: self)
        presenter.view = vc
        
        vc.presenter = presenter
        return vc
    }
    
//    func showCart(from: ListView) {
//        let cartRouter = CartRouter()
//        from.navigationController?.pushViewController(cartRouter.view, animated: true)
//    }
}
