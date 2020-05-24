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
    @EnvironmentObject var localMarketsViewModel: LocalMarketsViewModel

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        updateLocation(mapView, newCoordinate: mapViewModel.currentMapCoordinate.coordinate)
        updateAnnotations(mapView, annotations: localMarketsViewModel.marketAnnotations)
    }

    private func updateLocation(_ mapView: MKMapView, newCoordinate: CLLocationCoordinate2D) {
        guard newCoordinate != kCLLocationCoordinate2DInvalid else {
            print("Invalid")
            return
        }

        guard mapView.centerCoordinate != newCoordinate else {
            return
        }

        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: mapViewModel.currentMapCoordinate.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }

    private func updateAnnotations(_ mapView: MKMapView, annotations: [MKAnnotation]) {

        let newAnnotations = annotations.filter { annotation in
            return !mapView.annotations.contains(where: { $0.coordinate == annotation.coordinate })
        }

        mapView.addAnnotations(newAnnotations)
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
