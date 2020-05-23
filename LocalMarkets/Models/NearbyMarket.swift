//
//  Market.swift
//  LocalMarkets
//
//  Created by Michael Koch on 5/17/20.
//  Copyright © 2020 Michael Koch. All rights reserved.
//

import Foundation

struct NearbyMarketsResponse: Codable {

    var markets: [NearbyMarket]

    enum CodingKeys: String, CodingKey {
        case markets = "results"
    }

}

struct NearbyMarket: Codable, Identifiable {

    enum ParsingError: Error {
        case invalidJSON
    }

    enum CodingKeys: String, CodingKey {
        case id
        case marketName = "marketname"
    }

    var id: String
    var marketName: String
    var distance: Double

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)

        let distanceAndName = try values.decode(String.self, forKey: .marketName)
        let components = distanceAndName.components(separatedBy: " ")

        guard components.count > 1, let componentDistance = Double(components[0]) else {
            throw ParsingError.invalidJSON
        }

        marketName = components.suffix(from: 1).joined(separator: " ")
        distance = componentDistance
    }
}
