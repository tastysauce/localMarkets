//
//  LocationProvider.swift
//  LocalMarkets
//
//  Created by Michael Koch on 5/16/20.
//  Copyright © 2020 Michael Koch. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

extension CLLocationCoordinate2D: Equatable {}

public func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}

struct Location: Equatable {
    var latitude: Double
    var longitude: Double

    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

    init(coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    static var invalidLocation: Location {
        Location(coordinate: kCLLocationCoordinate2DInvalid)
    }

    public static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.coordinate == rhs.coordinate && lhs.coordinate == rhs.coordinate
    }
}

class LocationProvider: NSObject, ObservableObject {

    @Published var location: Location = .invalidLocation

    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        configureLocationManager()
    }

    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

}

extension LocationProvider: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            print("oh no")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocationCoordinate = locations.last?.coordinate else {
            print("No locations")
            return
        }

        location = Location(coordinate: mostRecentLocationCoordinate)
    }

}
