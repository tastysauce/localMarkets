//
//  NearbyMarkets.swift
//  LocalMarkets
//
//  Created by Michael Koch on 5/17/20.
//  Copyright © 2020 Michael Koch. All rights reserved.
//

import Foundation

class NearbyMarkets: ObservableObject {

    @Published var markets: [Market] = []

    private let marketsAPIClient: MarketsAPIClient
    private let locationProvider: LocationProvider

    init(
        marketsAPIClient: MarketsAPIClient,
        locationProvider: LocationProvider) {
        self.marketsAPIClient = marketsAPIClient
        self.locationProvider = locationProvider
    }

    public func getNearbyMarkets() {
        let currentLocation = locationProvider.location
        marketsAPIClient.requestMarkets(nearby: currentLocation)
    }

}
