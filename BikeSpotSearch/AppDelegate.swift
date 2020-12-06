//
//  AppDelegate.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/02.
//

import UIKit
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if let apikey = getGoogleMapKey {
            GMSServices.provideAPIKey(apikey)
        }
        return true
    }

}

extension AppDelegate {

    var getGoogleMapKey: String? {
        return APIKeyManager().getValue(key: "GoogleMapKey") as? String
    }
}
