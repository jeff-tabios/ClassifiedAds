//
//  ClassifiedAds.swift
//  ClassifiedAds
//
//  Created by Jeffrey Tabios on 12/20/21.
//

import Foundation

// MARK: - ClassifiedAds
struct ClassifiedAds: Codable {
    let results: [Ad]?
    let pagination: Pagination?
    
    enum CodingKeys: String, CodingKey {
        case results, pagination
    }
}

// MARK: - Pagination
struct Pagination: Codable {
    let key: JSONNull?
    
    enum CodingKeys: String, CodingKey {
        case key
    }
}

// MARK: - Result
struct Ad: Codable {
    let createdAt: String?
    let price, name, uid: String?
    let imageIDS: [String]?
    let imageUrls, imageUrlsThumbnails: [String]?

    enum CodingKeys: String, CodingKey {
        case createdAt
        case price, name, uid
        case imageIDS
        case imageUrls
        case imageUrlsThumbnails
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    func hash(into hasher: inout Hasher) {
        
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
