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
    private (set) lazy var tabBarController = MainTabBarController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Migration().migration()

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()

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
