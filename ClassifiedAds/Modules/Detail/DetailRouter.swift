//
//  DetailRouter.swift
//  ClassifiedAds
//
//  Created by Jeffrey Tabios on 12/21/21.
//

import Foundation
import UIKit

class DetailRouter {
    
    var ad: Ad
    
    var view: DetailView {
        let vc = DetailView()
        let presenter = DetailPresenter(ad: ad)
        vc.presenter = presenter
        return vc
    }
    
    init(ad: Ad) {
        self.ad = ad
    }
}
