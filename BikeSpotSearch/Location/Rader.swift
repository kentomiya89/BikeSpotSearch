//
//  Rader.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/05.
//

import UIKit
import Foundation
import CoreLocation

class Radar: NSObject {

    static let shared = Radar()

    var locationManager: CLLocationManager {
        didSet {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
            locationManager.delegate = self
        }
    }

    override init() {
        locationManager = CLLocationManager()
        super.init()
    }

    func start() {
        guard  #available(iOS 14, *) else {
            requestPermissonVeriOS13()
            return
        }
        locationManager.startUpdatingLocation()
    }

    // iOS 13でのリクエスト
    func requestPermissonVeriOS13() {
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

extension Radar: CLLocationManagerDelegate {

    // iOS 13
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 位置情報許可
        switch status {
        case .notDetermined:
            // 位置情報
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }

    // iOS 14
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

        if #available(iOS 14.0, *) {
            // 位置情報許可
            switch manager.authorizationStatus {
            case .notDetermined:
                // 位置情報
                manager.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
            default:
                break
            }

            // 正確性
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
        guard let mostRecentLocation = locations.last else { return }
        NotificationCenter.default.post(name: .currentLocation, object: nil, userInfo: [NotificationUserInfoDefine.currentLocation: mostRecentLocation])
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

}
