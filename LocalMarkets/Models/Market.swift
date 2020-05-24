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
    var name: String
    var distance: Double

    // from NearbyMarketDetails
    var address: String
    var googleMapsLink: URL
    var products: String // TODO: Make an enum for the products!
    var schedule: String // TODO: This will need parsing
    var location: Location

    init(
        nearbyMarket: NearbyMarket,
        nearbyMarketDetails: NearbyMarketDetails) {
        self.id = nearbyMarket.id
        self.name = nearbyMarket.name
        self.distance = nearbyMarket.distance
        self.address = nearbyMarketDetails.address
        self.googleMapsLink = nearbyMarketDetails.googleMapsLink
        self.products = nearbyMarketDetails.products
        self.schedule = nearbyMarketDetails.schedule
        self.location = Market.parseLocation(from: googleMapsLink)
    }

    private static func parseLocation(from url: URL) -> Location {
        guard let urlComponents = URLComponents(string: url.absoluteString),
            let firstQueryValue = urlComponents.queryItems?.first?.value else {
                return .invalidLocation
        }

        let stringComponents = firstQueryValue.components(separatedBy: " ")
        guard stringComponents.count >= 2 else {
            return .invalidLocation
        }

        guard let cleanLatitude = stringComponents.first?.replacingOccurrences(of: ",", with: ""),
            let latitude = Double(cleanLatitude),
            let longitude = Double(stringComponents[1]) else {
                return .invalidLocation
        }

        return Location(latitude: latitude, longitude: longitude)
    }

}
