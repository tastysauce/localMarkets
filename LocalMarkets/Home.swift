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

    private let mapViewModel: MapViewModel

    init(mapViewModel: MapViewModel) {
        self.mapViewModel = mapViewModel
    }

    var body: some View {
        ZStack {
            MapView()
                .environmentObject(mapViewModel)

            VStack {
                Button(action: {
                    self.nearbyMarkets.getNearbyMarkets()
                }) {
                    Text("Get nearby markets")
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
        Home(mapViewModel: MapViewModel(locationProvider: LocationProvider()))
            .environmentObject(LocationProvider())
            .environmentObject(NearbyMarkets.mockNearbyMarkets)
    }
}
