//
//  MarketAnnotation.swift
//  LocalMarkets
//
//  Created by Michael Koch on 5/23/20.
//  Copyright © 2020 Michael Koch. All rights reserved.
//

import Foundation
import MapKit

class MarketAnnotation: NSObject, MKAnnotation {

    let id: String
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D

    init(market: Market) {
        self.id = market.id
        self.title = market.name
        self.subtitle = "something"
        self.coordinate = market.location.coordinate
    }

}
