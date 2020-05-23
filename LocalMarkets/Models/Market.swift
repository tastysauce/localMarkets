//
//  Market.swift
//  LocalMarkets
//
//  Created by Michael Koch on 5/23/20.
//  Copyright © 2020 Michael Koch. All rights reserved.
//

import Foundation

struct Market {

    // from NearbyMarket
    var id: String
    var marketName: String
    var distance: Double

    // from NearbyMarketDetails
    var address: String
    var googleMapsLink: URL
    var products: String // TODO: Make an enum for the products!
    var schedule: String // TODO: This will need parsing

    var location: Location = .invalidLocation

    init(
        nearbyMarket: NearbyMarket,
        nearbyMarketDetails: NearbyMarketDetails) {
        self.id = nearbyMarket.id
        self.marketName = nearbyMarket.marketName
        self.distance = nearbyMarket.distance
        self.address = nearbyMarketDetails.address
        self.googleMapsLink = nearbyMarketDetails.googleMapsLink
        self.products = nearbyMarketDetails.products
        self.schedule = nearbyMarketDetails.schedule
    }

}
