//
//  MapView.swift
//  LocalMarkets
//
//  Created by Michael Koch on 5/16/20.
//  Copyright © 2020 Michael Koch. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {

    var coordinate: CLLocationCoordinate2D

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)
    }

}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(coordinate: CLLocationCoordinate2D(latitude: 37.509280, longitude: -122.303370))
    }
}
