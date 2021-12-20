//
//  UIView+.swift
//  ClassifiedAds
//
//  Created by Jeffrey Tabios on 12/20/21.
//

import Foundation
import UIKit

// MARK: Identifiable
extension UIView: Identifiable {
    static var identity: String {
        return String(describing: self)
    }
}
