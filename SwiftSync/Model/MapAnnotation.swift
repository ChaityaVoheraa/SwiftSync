//
//  MapAnnotation.swift
//  SwiftSync
//
//  Created by Chaitya Vohera on 03/04/24.
//

import Foundation
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D

    init(title: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
