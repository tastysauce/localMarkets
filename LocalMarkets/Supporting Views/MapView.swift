//
//  MapView.swift
//  LocalMarkets
//
//  Created by Michael Koch on 5/16/20.
//  Copyright © 2020 Michael Koch. All rights reserved.
//

import SwiftUI
import MapKit
import Combine

struct MapView: UIViewRepresentable {

    @EnvironmentObject var mapViewModel: MapViewModel

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        guard mapViewModel.userLocation.coordinate != kCLLocationCoordinate2DInvalid else {
            print("Invalid")
            return
        }

        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: mapViewModel.userLocation.coordinate, span: span)
        uiView.setRegion(region, animated: true)
    }

}

class MapViewCoordinator: NSObject, MKMapViewDelegate {

    @Published var mapCenterCoordinate: Location = .invalidLocation

    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        mapCenterCoordinate = Location(coordinate: mapView.centerCoordinate)
    }

}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
