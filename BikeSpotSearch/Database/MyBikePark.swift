//
//  MyBikePark.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/09.
//

import Foundation
import RealmSwift

class MyBikePark: Object {
    @objc dynamic var bikeSpotId: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var lon: Double = 0.0

    override static func primaryKey() -> String? {
        return "bikeSpotId"
    }
}
