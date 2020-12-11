//
//  MainTabBarController.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/07.
//

import UIKit

enum TabTag: Int {
    case map = 1
    case mybikePark = 2
}

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 地図タブ
        let topMap = StoryboardScene.TopMap.initialScene.instantiate()
        let topMapModel = TopMapModel()
        let topMapPresenter = TopMapPresenter(view: topMap, model: topMapModel)
        topMap.inject(presenter: topMapPresenter)

        topMap.tabBarItem = UITabBarItem(title: L10n.mapTab, image: Asset.map.image, tag: TabTag.map.rawValue)
        let mapNavi = UINavigationController(rootViewController: topMap)

        // My駐輪場タブ
        let myBikePark = StoryboardScene.MyBikeParkList.initialScene.instantiate()
        let myBikeParkModel = MyBikeParkListModel()
        let myBikeParkPresenter = MyBikeParkListPresenter(view: myBikePark, model: myBikeParkModel)
        myBikePark.inject(presenter: myBikeParkPresenter)

        myBikePark.tabBarItem = UITabBarItem(title: L10n.myBikeParkTab, image: Asset.myBikePark.image, tag: TabTag.mybikePark.rawValue)
        let myBikeParkNavi = UINavigationController(rootViewController: myBikePark)

        self.viewControllers = [mapNavi, myBikeParkNavi]
    }
}
