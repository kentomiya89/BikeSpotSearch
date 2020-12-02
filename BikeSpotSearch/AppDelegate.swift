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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if let apikey = getGoogleMapKey {
            GMSServices.provideAPIKey(apikey)
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

}

extension AppDelegate {

    var getGoogleMapKey: String? {
        return APIKeyManager().getValue(key: "GoogleMapKey") as? String
    }
}
