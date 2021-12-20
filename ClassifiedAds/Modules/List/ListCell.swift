//
//  ListCell.swift
//  ClassifiedAds
//
//  Created by Jeffrey Tabios on 12/20/21.
//

import Foundation
import UIKit
import CachedImage

class ListCell: UICollectionViewCell {
    
    lazy var image: AsyncCachedImage = {
        let imageView = AsyncCachedImage()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var price: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
    }
    
    func configure() {
        backgroundColor = .white
        layer.borderWidth = 0.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 1.3
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
    }
    
    func addSubviews() {
        self.contentView.addSubview(image)
        self.contentView.addSubview(title)
        self.contentView.addSubview(price)
        
        setNeedsUpdateConstraints()
    }
    
    
    override func updateConstraints() {
        image.snp.remakeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(image.snp.width)
        }
        
        title.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(image.snp.bottom).offset(10)
            make.width.equalToSuperview()
        }
        
        price.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(title.snp.bottom).offset(5)
            make.width.equalToSuperview()
        }
        
        super.updateConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.image.image = nil
    }
}
