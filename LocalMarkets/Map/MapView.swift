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
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        guard mapViewModel.currentMapCoordinate.coordinate != kCLLocationCoordinate2DInvalid else {
            print("Invalid")
            return
        }

        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: mapViewModel.currentMapCoordinate.coordinate, span: span)
        uiView.setRegion(region, animated: true)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(
            parent: self,
            mapViewModel: mapViewModel
        )
    }

    class Coordinator: NSObject, MKMapViewDelegate {

        private let parent: MapView
        private let mapViewModel: MapViewModel

        init(parent: MapView,
             mapViewModel: MapViewModel) {
            self.parent = parent
            self.mapViewModel = mapViewModel
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            mapViewModel.currentMapCoordinate = Location(coordinate: mapView.centerCoordinate)
        }

    }

}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
