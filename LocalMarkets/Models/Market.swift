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
    let id: String
    let name: String
    let distance: Double

    // from NearbyMarketDetails
    let address: String
    let googleMapsLink: URL
    let products: String // TODO: Make an enum for the products!
    let schedule: String // TODO: This will need parsing
    let location: Location

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

    public static var mockMarket: Market = {
        Market(nearbyMarket: NearbyMarket.mockNearbyMarket, nearbyMarketDetails: NearbyMarketDetails.mockNearbyMarketDetails)
    }()

}
