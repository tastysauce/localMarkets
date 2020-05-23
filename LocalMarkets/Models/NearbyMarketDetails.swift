//
//  MarketDetails.swift
//  LocalMarkets
//
//  Created by Michael Koch on 5/23/20.
//  Copyright © 2020 Michael Koch. All rights reserved.
//

import Foundation


struct NearbyMarketDetailsResponse: Codable {

    var marketDetails: NearbyMarketDetails

    enum CodingKeys: String, CodingKey {
        case marketDetails = "marketdetails"
    }

}

struct NearbyMarketDetails: Codable {

    var address: String
    var googleMapsLink: URL
    var products: String // TODO: Make an enum for the products!
    var schedule: String // TODO: This will need parsing
    // Calculated var lat/lon

    enum CodingKeys: String, CodingKey {
        case address = "Address"
        case googleMapsLink = "GoogleLink"
        case products = "Products"
        case schedule = "Schedule"
    }

}
