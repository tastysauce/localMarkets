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
    @Published var marketAnnotations: [MarketAnnotation] = []
    public var selectedMarket = PassthroughSubject<Market, Never>()

    private let marketsAPIClient: MarketsAPIClient
    private var disposeBag: Set<AnyCancellable> = []

    init(marketsAPIClient: MarketsAPIClient) {
        self.marketsAPIClient = marketsAPIClient

        // Add annotations to the map once we have markets
        $markets
            .map { $0.map { MarketAnnotation(market: $0) } }
            .assign(to: \.marketAnnotations, on: self)
            .store(in: &disposeBag)
    }

    public func getNearbyMarkets(for currentLocation: Location) {
        marketsAPIClient.requestMarkets(nearby: currentLocation)
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .map(\.marketsInResponse)
            .flatMap { self.getDetailsForAll(nearbyMarkets: $0) }
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .assign(to: \.markets, on: self)
            .store(in: &disposeBag)
    }

    public func marketAnnotationSelected(id: String) {
        // Find the market by ID and publish it
        guard let market = self.markets.first(where: { return $0.id == id } ) else {
            print("Couldn't find market by ID")
            return
        }
        selectedMarket.send(market)
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
