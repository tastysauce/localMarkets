//
//  Home.swift
//  LocalMarkets
//
//  Created by Michael Koch on 5/16/20.
//  Copyright © 2020 Michael Koch. All rights reserved.
//

import SwiftUI

struct Home: View {

    @ObservedObject private var localMarkets: LocalMarketsViewModel
    @ObservedObject private var mapViewModel: MapViewModel
    @State private var annotationViewIsPresented = false

    init(localMarkets: LocalMarketsViewModel,
         mapViewModel: MapViewModel) {
        self.localMarkets = localMarkets
        self.mapViewModel = mapViewModel
    }

    var body: some View {

        ZStack {
            MapView(localMarketsViewModel: localMarkets, mapViewModel: mapViewModel)
                .edgesIgnoringSafeArea(.all)
                // Receives taps of market annnotations
                .onReceive(localMarkets.$selectedMarket) { market in
                    guard let _ = market else {
                        return
                    }
                    annotationViewIsPresented = true
                }
                
                .sheet(isPresented: $annotationViewIsPresented) {
                    annotationViewIsPresented = false
                } content: {
                    MarketDetailView(market: localMarkets.selectedMarket)
                }

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

            }

        }
        
    }

}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(localMarkets: LocalMarketsViewModel.mockLocalMarkets, mapViewModel: MapViewModel(locationProvider: LocationProvider()))
    }
}
