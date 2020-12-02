//
//  ViewController.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/02.
//

import UIKit
import GoogleMaps

class TopMapViewController: UIViewController {

    var locationManager: CLLocationManager! {
        didSet {
            locationManager.delegate = self
        }
    }

    @IBOutlet weak var mapView: GMSMapView! {
        didSet {
            mapView.isMyLocationEnabled = true
            mapView.settings.compassButton = true
            mapView.settings.myLocationButton = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        requestLocation()
    }

    func requestLocation() {
        locationManager.requestAlwaysAuthorization()
        let status = CLLocationManager.authorizationStatus()

        switch status {
        case .authorizedWhenInUse,
             .authorizedAlways:
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }

}

// MARK: CLLocationManagerDelegate
extension TopMapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            mapView.camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                      longitude: location.coordinate.longitude,
                                                      zoom: 13.0)
        }
    }

}
