//
//  MarketDetailList.swift
//  LocalMarkets
//
//  Created by Michael Koch on 3/9/21.
//  Copyright © 2021 Michael Koch. All rights reserved.
//

import SwiftUI

struct MarketDetailList: View {

    var market: Market

    /*

     var name: String
     var distance: Double

     // from NearbyMarketDetails
     var address: String
     var googleMapsLink: URL
     var products: String // TODO: Make an enum for the products!
     var schedule: String // TODO: This will need parsing
     var location: Location

     */

    var body: some View {
        List {
            ListRow(title: "Name: ") {
                Text(market.name)
            }
            ListRow(title: "Address: ") {
                Text(market.address)
            }
        }
    }
}

struct MarketDetailList_Previews: PreviewProvider {
    static var previews: some View {
        MarketDetailList(market: Market.mockMarket)
    }
}
