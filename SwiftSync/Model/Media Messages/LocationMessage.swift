//
//  LocationMessage.swift
//  SwiftSync
//
//  Created by Chaitya Vohera on 03/04/24.
//

import CoreLocation
import Foundation
import MessageKit

class LocationMessage: NSObject, LocationItem {
    var location: CLLocation
    var size: CGSize

    init(location: CLLocation) {
        self.location = location
        self.size = CGSize(width: 240, height: 240)
    }
}
