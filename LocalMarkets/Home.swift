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
    private let mapView = MapView()
    @State private var isPresented = false
    

    var body: some View {
        
        ZStack {
            self.mapView
                .edgesIgnoringSafeArea(.all)

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
        .onReceive(self.localMarkets.selectedMarket, perform: { markets in
            isPresented = true
        })
        .sheet(isPresented: $isPresented, onDismiss: {
            isPresented = false
        }, content: {
            MarketDetailView()
        })

    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environmentObject(LocalMarketsViewModel.mockLocalMarkets)
            .environmentObject(MapViewModel(locationProvider: LocationProvider()))
    }
}
