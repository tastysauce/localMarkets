//
//  Home.swift
//  LocalMarkets
//
//  Created by Michael Koch on 5/16/20.
//  Copyright © 2020 Michael Koch. All rights reserved.
//

import SwiftUI

struct Home: View {

    @EnvironmentObject private var localMarkets: LocalMarketsViewModel
    @EnvironmentObject private var mapViewModel: MapViewModel

    var body: some View {
        ZStack {
            MapView()
                .environmentObject(mapViewModel)

            VStack {
                Button(action: {
                    self.localMarkets.getNearbyMarkets(for: self.mapViewModel.currentMapCoordinate)
                }) {
                    Text("Get nearby markets")
                }
                Button(action: {
                    self.mapViewModel.centerOnUser()
                }) {
                    Text("Center map on me")
                }

                if localMarkets.markets.isEmpty {
                    Text("lol")
                } else {
                    List {
                        ForEach(localMarkets.markets, id: \.id) { market in
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
            .environmentObject(LocalMarketsViewModel.mockLocalMarkets)
            .environmentObject(MapViewModel(locationProvider: LocationProvider()))
    }
}
