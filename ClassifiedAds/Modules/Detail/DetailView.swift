//
//  DetailView.swift
//  ClassifiedAds
//
//  Created by Jeffrey Tabios on 12/21/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import CachedImage

final class DetailView: UIViewController {
    
    let disposeBag = DisposeBag()
    var presenter: DetailPresenter?
    
    lazy var image: AsyncCachedImage = {
        let imageView = AsyncCachedImage()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .red
        return imageView
    }()
    
    lazy var titleName: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var price: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        configure()
    }
    
    func configure() {
        if let ad = presenter?.ad {
                
            if let adImageUrl = ad.imageUrlsThumbnails?[0] {
                let adImageId = ad.imageIDS[0]
                self.image.loadImage(from: URL(string: adImageUrl)!, cacheId: adImageId)
            }
            
            if let adTitle = ad.name,
               let adPrice = ad.price {
                self.titleName.text = adTitle.capitalized
                self.price.text = adPrice
            }
        }
        
    }
    
    func addSubviews() {
        view.addSubview(image)
        view.addSubview(titleName)
        view.addSubview(price)
        
        self.view.setNeedsUpdateConstraints()
    }
    
    
    override func updateViewConstraints() {
        image.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(self.view.safeArea.top)
            make.width.equalToSuperview()
            make.height.equalTo(image.snp.width)
        }
        
        titleName.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(image.snp.bottom).offset(10)
            make.width.equalToSuperview()
        }
        
        price.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(titleName.snp.bottom).offset(5)
            make.width.equalToSuperview()
        }
        
        super.updateViewConstraints()
    }
    
}
