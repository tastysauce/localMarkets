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

    var body: some View {
        MapView()
            .environmentObject(locationProvider)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environmentObject(LocationProvider())
    }
}
