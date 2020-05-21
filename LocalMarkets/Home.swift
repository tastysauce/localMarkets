//
//  Home.swift
//  LocalMarkets
//
//  Created by Michael Koch on 5/16/20.
//  Copyright © 2020 Michael Koch. All rights reserved.
//

import SwiftUI

struct Home: View {

    @EnvironmentObject private var locationProvider: LocationProvider
    @EnvironmentObject private var nearbyMarkets: NearbyMarkets
    @EnvironmentObject private var mapViewModel: MapViewModel

    var body: some View {
        ZStack {
            MapView()
                .environmentObject(mapViewModel)

            VStack {
                Button(action: {
                    self.nearbyMarkets.getNearbyMarkets(for: self.mapViewModel.mapCenterCoordinate)
                }) {
                    Text("Get nearby markets")
                }
                Button(action: {
                    self.mapViewModel.centerOnUser()
                }) {
                    Text("Center map on me")
                }

                if nearbyMarkets.markets.isEmpty {
                    Text("lol")
                } else {
                    List {
                        ForEach(nearbyMarkets.markets, id: \.id) { market in
                            Text("name: \(market.marketName)")
                        }
                    }
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environmentObject(LocationProvider())
            .environmentObject(NearbyMarkets.mockNearbyMarkets)
            .environmentObject(MapViewModel(locationProvider: LocationProvider()))
    }
}
