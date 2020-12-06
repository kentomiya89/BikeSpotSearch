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

        let topMap = StoryboardScene.TopMap.initialScene.instantiate()

        let navigaitonController = UINavigationController(rootViewController: topMap)

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navigaitonController
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
