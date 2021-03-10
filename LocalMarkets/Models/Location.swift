//
//  Location.swift
//  LocalMarkets
//
//  Created by Michael Koch on 5/23/20.
//  Copyright © 2020 Michael Koch. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Equatable {}

public func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}

struct Location: Equatable {

    let latitude: Double
    let longitude: Double

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
