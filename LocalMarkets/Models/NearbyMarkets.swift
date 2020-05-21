//
//  NearbyMarkets.swift
//  LocalMarkets
//
//  Created by Michael Koch on 5/17/20.
//  Copyright © 2020 Michael Koch. All rights reserved.
//

import Foundation
import Combine

class NearbyMarkets: ObservableObject {

    @Published var markets: [Market] = []

    private let marketsAPIClient: MarketsAPIClient
    private var disposeBag: Set<AnyCancellable> = []

    init(marketsAPIClient: MarketsAPIClient) {
        self.marketsAPIClient = marketsAPIClient
    }

    public func getNearbyMarkets(for currentLocation: Location) {
        marketsAPIClient.requestMarkets(nearby: currentLocation)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .map(\.markets)
            .replaceError(with: [])
            .assign(to: \.markets, on: self)
            .store(in: &disposeBag)
    }

    static var mockNearbyMarkets: NearbyMarkets {
        return NearbyMarkets(marketsAPIClient: MarketsAPIClient(apiClient: APIClient()))
    }

}
