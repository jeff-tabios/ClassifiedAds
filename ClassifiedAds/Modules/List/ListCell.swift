//
//  ListCell.swift
//  ClassifiedAds
//
//  Created by Jeffrey Tabios on 12/20/21.
//

import Foundation
import UIKit

class ListCell: UICollectionViewCell {
    
    lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        backgroundColor = .white
        layer.cornerRadius = 10.0
        layer.borderWidth = 0.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 1.3
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
    }
    
    func addSubviews() {
        self.contentView.addSubview(image)
        
        setNeedsUpdateConstraints()
    }
    
    
    override func updateConstraints() {
        image.snp.remakeConstraints { (make) -> Void in
            make.width.height.equalToSuperview()
        }
        
        super.updateConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.image.image = nil
    }
}
