//
//  MainTabBarController.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/07.
//

import UIKit

enum TabTag: Int {
    case map = 1
    case other = 2
}

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 地図タブ
        let topMap = StoryboardScene.TopMap.initialScene.instantiate()
        topMap.tabBarItem = UITabBarItem(title: L10n.map, image: Asset.map.image, tag: TabTag.map.rawValue)
        let mapNavi = UINavigationController(rootViewController: topMap)

        // その他タブ
        let other = StoryboardScene.Other.initialScene.instantiate()
        other.tabBarItem = UITabBarItem(title: L10n.other, image: Asset.other.image, tag: TabTag.other.rawValue)
        let otherNavi = UINavigationController(rootViewController: other)

        self.viewControllers = [mapNavi, otherNavi]
    }
}
