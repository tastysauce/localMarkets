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

    @ObservedObject var localMarketsViewModel: LocalMarketsViewModel
    @ObservedObject var mapViewModel: MapViewModel

    init(localMarketsViewModel: LocalMarketsViewModel,
         mapViewModel: MapViewModel) {
        self.mapViewModel = mapViewModel
        self.localMarketsViewModel = localMarketsViewModel
    }

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

    func marketAnnotationSelected(annotation: MarketAnnotation) {
        localMarketsViewModel.marketAnnotationSelected(id: annotation.id)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {

        private let parent: MapView

        init(parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            parent.mapViewModel.currentMapCoordinate = Location(coordinate: mapView.centerCoordinate)
        }

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let marketAnnotation = view.annotation as? MarketAnnotation else {
                print("Not the right annotation")
                return
            }

            parent.marketAnnotationSelected(annotation: marketAnnotation)
        }

    }

}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(localMarketsViewModel: LocalMarketsViewModel.mockLocalMarkets, mapViewModel: MapViewModel(locationProvider: LocationProvider()))
    }
}
