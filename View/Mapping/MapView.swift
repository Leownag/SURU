//
//  MapView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/16.
//

import UIKit
import MapKit
import Kingfisher

class MapView: MKMapView {
    
    func layoutView(from stores: [Store]) {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height)
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 25.09108, longitude: 121.5598), latitudinalMeters: 20000, longitudinalMeters: 20000)
        if !stores.isEmpty {
            for store in stores {
                let mark = MKPointAnnotation()
                mark.coordinate =  CLLocationCoordinate2D(
                    latitude: store.coordinate.lat,
                    longitude: store.coordinate.long)
                mark.title = store.name
                self.addAnnotation(mark)
            }
        }
    }
}
