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
            locationManager.distanceFilter = 10
        }
    }

    @IBOutlet weak var mapView: GMSMapView! {
        didSet {
            mapView.isMyLocationEnabled = true
            mapView.settings.compassButton = true
            mapView.settings.myLocationButton = true
        }
    }

    private var presenter: TopMapPresenterInput!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.presenter = TopMapPresenter(view: self)
        // MARK: TODO LocationManager用のクラスを後で作る
        locationManager = CLLocationManager()

        if #available(iOS 14, *) {
            // 何か後で記載するかも
        } else {
            // 従来のリクエスト
            requestLocation()
        }

        presenter.viewDidLoad()
    }

    // iOS 13でのリクエスト
    func requestLocation() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse,
             .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }

}

extension TopMapViewController: TopMapPresenterOutPut {

}

// MARK: CLLocationManagerDelegate
extension TopMapViewController: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // 位置情報許可
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .notDetermined:
                // 位置情報
                manager.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
            default:
                break
            }
        }

        // 正確性
        if #available(iOS 14.0, *) {
            let accuracyAuthorization = manager.accuracyAuthorization
            switch accuracyAuthorization {
            case .reducedAccuracy:
                manager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "Accuracy")
            default:
                break
            }
        }

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            mapView.camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                      longitude: location.coordinate.longitude,
                                                      zoom: 13.0)
        }
    }

}
