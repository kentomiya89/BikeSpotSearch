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

    var savedTabIndex = 0

    // 地図タブ
    var mapNavi: UINavigationController {
        let topMap = StoryboardScene.TopMap.initialScene.instantiate()
        let topMapModel = TopMapModel()
        let topMapPresenter = TopMapPresenter(view: topMap, model: topMapModel)
        topMap.inject(presenter: topMapPresenter)

        topMap.tabBarItem = UITabBarItem(title: L10n.mapTab, image: Asset.map.image, tag: TabTag.map.rawValue)
        return UINavigationController(rootViewController: topMap)
    }

    // My駐輪場タブ
    var myBikeParkNavi: UINavigationController {
        let myBikePark = StoryboardScene.MyBikeParkList.initialScene.instantiate()
        let myBikeParkModel = MyBikeParkListModel()
        let myBikeParkPresenter = MyBikeParkListPresenter(view: myBikePark, model: myBikeParkModel)
        myBikePark.inject(presenter: myBikeParkPresenter)

        myBikePark.tabBarItem = UITabBarItem(title: L10n.myBikeParkTab, image: Asset.myBikePark.image, tag: TabTag.mybikePark.rawValue)
        let myBikeParkNavi = UINavigationController(rootViewController: myBikePark)
        return myBikeParkNavi
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewControllers = [mapNavi, myBikeParkNavi]

        NotificationCenter.default.addObserver(self, selector: #selector(willTerminate), name: UIApplication.willTerminateNotification, object: nil)

        selectedIndex = UserDefaults.standard.integer(forKey: UserDefaultDefine.tabBarSelectedIndex)
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        savedTabIndex = selectedIndex
    }

    @objc func willTerminate() {
        UserDefaults.standard.set(savedTabIndex, forKey: UserDefaultDefine.tabBarSelectedIndex)
    }

}
