//
//  NearbyMarkets.swift
//  LocalMarkets
//
//  Created by Michael Koch on 5/17/20.
//  Copyright © 2020 Michael Koch. All rights reserved.
//

import Foundation
import Combine

class LocalMarketsViewModel: ObservableObject {

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
            .flatMap { self.getDetailsForAll(nearbyMarkets: $0) }
            .replaceError(with: [])
            .assign(to: \.markets, on: self)
            .store(in: &disposeBag)
    }

    private func getDetailsForAll(nearbyMarkets: [NearbyMarket]) -> AnyPublisher<[Market], Error> {
        let arrayOfPublishers = nearbyMarkets.map { getDetailsFor(nearbyMarket: $0) }
        let sequenceOfPublishers = Publishers.Sequence<[AnyPublisher<Market, Error>], Error>(sequence: arrayOfPublishers)
        let marketsPublisher = sequenceOfPublishers.flatMap { $0 }.collect().eraseToAnyPublisher()
        return marketsPublisher
    }

    private func getDetailsFor(nearbyMarket: NearbyMarket) -> AnyPublisher<Market, Error> {
        marketsAPIClient.requestMarketDetails(for: nearbyMarket)
            .map { Market(nearbyMarket: nearbyMarket, nearbyMarketDetails: $0.marketDetails) }
            .eraseToAnyPublisher()
    }

    static var mockLocalMarkets: LocalMarketsViewModel {
        return LocalMarketsViewModel(marketsAPIClient: MarketsAPIClient(apiClient: APIClient()))
    }

}
