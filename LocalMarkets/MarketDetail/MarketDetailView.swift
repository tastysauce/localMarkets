//
//  MarketDetailView.swift
//  LocalMarkets
//
//  Created by Michael Koch on 3/1/21.
//  Copyright © 2021 Michael Koch. All rights reserved.
//

import SwiftUI

struct MarketDetailView: View {

    private let market: Market?

    init(market: Market?) {
        self.market = market
    }

    var body: some View {
        Text(self.market?.name ?? "what")
    }
}

struct MarketDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MarketDetailView(market: Market.mockMarket)
    }
}
