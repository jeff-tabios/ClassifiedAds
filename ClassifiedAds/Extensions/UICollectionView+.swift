//
//  UICollectionView+.swift
//  ClassifiedAds
//
//  Created by Jeffrey Tabios on 12/20/21.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func dequeueCellAtIndexPath<T: UICollectionViewCell>(indexPath: IndexPath) -> T {
        if let cell = dequeueReusableCell(withReuseIdentifier: T.identity, for: indexPath) as? T {
            return cell
        } else {
            fatalError("cell with \"\(T.identity)\" identifier is not registered!")
        }
    }
}
