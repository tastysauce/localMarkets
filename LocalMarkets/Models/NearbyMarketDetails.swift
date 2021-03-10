//
//  MarketDetails.swift
//  LocalMarkets
//
//  Created by Michael Koch on 5/23/20.
//  Copyright © 2020 Michael Koch. All rights reserved.
//

import Foundation


struct NearbyMarketDetailsResponse: Codable {

    let marketDetails: NearbyMarketDetails

    enum CodingKeys: String, CodingKey {
        case marketDetails = "marketdetails"
    }

}

struct NearbyMarketDetails: Codable {

    let address: String
    let googleMapsLink: URL
    let products: String // TODO: Make an enum for the products!
    let schedule: String // TODO: This will need parsing
    // Calculated var lat/lon

    enum CodingKeys: String, CodingKey {
        case address = "Address"
        case googleMapsLink = "GoogleLink"
        case products = "Products"
        case schedule = "Schedule"
    }

    public static var mockNearbyMarketDetails: NearbyMarketDetails = {
        NearbyMarketDetails(address: "123 fake drive", googleMapsLink: URL(string: "www.google.com")!, products: "Foods", schedule: "All day")
    }()
}
