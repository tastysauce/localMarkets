//
//  MapViewModel.swift
//  LocalMarkets
//
//  Created by Michael Koch on 5/20/20.
//  Copyright © 2020 Michael Koch. All rights reserved.
//

import Foundation
import Combine

class MapViewModel: ObservableObject {

    @Published public var userLocation: Location = .invalidLocation
    @Published public var mapCenterCoordinate: Location = .invalidLocation

    private let locationProvider: LocationProvider
    private let centerOnUserPublisher = PassthroughSubject<Void, Never>()
    private var disposeBag: Set<AnyCancellable> = []

    public init(locationProvider: LocationProvider) {
        self.locationProvider = locationProvider

        // Get and store initial location once we receive a valid one
        locationProvider.$location
            .first { $0 != Location.invalidLocation }
            .sink(receiveValue: { location in
                self.userLocation = location
                self.mapCenterCoordinate = location
            })
            .store(in: &disposeBag)

        // Vends the latest user location when a button is tapped
        centerOnUserPublisher
            .withLatestFrom(locationProvider.$location)
            .filter { $0 != Location.invalidLocation }
            .assign(to: \.userLocation, on: self)
            .store(in: &disposeBag)
    }

    public func centerOnUser() {
        centerOnUserPublisher.send(())
    }

}
