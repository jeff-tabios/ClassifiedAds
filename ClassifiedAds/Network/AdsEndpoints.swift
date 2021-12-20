//
//  Endpoints.swift
//  ClassifiedAds
//
//  Created by Jeffrey Tabios on 12/20/21.
//

import Foundation

enum AdsEndpoints: String {
    case ads = "https://ey3f2y0nre.execute-api.us-east-1.amazonaws.com/default/dynamodb-writer"
    
    var endpoint: String {
        self.rawValue
    }
}
