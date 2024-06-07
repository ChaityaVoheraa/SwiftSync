//
//  MapViewController.swift
//  SwiftSync
//
//  Created by Chaitya Vohera on 04/04/24.
//

import CoreLocation
import Foundation
import MapKit
import UIKit

class MapViewController: UIViewController {
    // MARK: - Vars

    var location: CLLocation?
    var mapView: MKMapView!
    
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTitle()
        configureMapView()
        configureLeftBarButton()
    }
    
    // MARK: - Configurations

    private func configureMapView() {
        mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        mapView.showsUserLocation = true
        
        if location != nil {
            mapView.setCenter(location!.coordinate, animated: false)
            mapView.addAnnotation(MapAnnotation(title: nil, coordinate: location!.coordinate))
        }
        
        view.addSubview(mapView)
    }
    
    private func configureLeftBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonPressed))
    }
    
    private func configureTitle() {
        title = "Map View"
    }
    
    // MARK: - Actions

    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}
