//
//  MarketDetails.swift
//  LocalMarkets
//
//  Created by Michael Koch on 5/23/20.
//  Copyright © 2020 Michael Koch. All rights reserved.
//

import Foundation

struct MarketDetails: Codable {

    var address: String
    var googleMapsLink: String
    var products: String // TODO: Make an enum for the products!
    var schedule: String // TODO: This will need parsing
    // Calculated var lat/lon

}
