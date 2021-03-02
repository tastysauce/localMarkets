//
//  Market.swift
//  LocalMarkets
//
//  Created by Michael Koch on 5/17/20.
//  Copyright © 2020 Michael Koch. All rights reserved.
//

import Foundation

struct NearbyMarketsResponse: Codable {

    var marketsInResponse: [NearbyMarket]

    enum CodingKeys: String, CodingKey {
        case marketsInResponse = "results"
    }
    
}

struct NearbyMarket: Codable, Identifiable {

    enum ParsingError: Error {
        case invalidJSON
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name = "marketname"
    }

    var id: String
    var name: String
    var distance: Double

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)

        let distanceAndName = try values.decode(String.self, forKey: .name)
        let components = distanceAndName.components(separatedBy: " ")

        guard components.count > 1, let componentDistance = Double(components[0]) else {
            throw ParsingError.invalidJSON
        }

        name = components.suffix(from: 1).joined(separator: " ")
        distance = componentDistance
    }
    
}
