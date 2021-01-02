//
//  Define.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/06.
//

import Foundation

struct LocationRelateNumber {
    static let searchRange = 3000.0
    static let zoomValue = 14.0
}

struct TableViewCellIdentifier {
    static let myBikeParkCell = "MyBikeParkCell"
}

enum PlaceSearchType: String {
    case bikePark
    case bikeShop

    var rawValue: String {
        switch self {
        case .bikePark: return L10n.bikePark
        case .bikeShop: return L10n.bikeShop
        }
    }
}

struct NibFileIdentifier {
    static let markerInfo = "MarkerInfo"
}

struct RealmDefine {
    static let sheamaVersion: UInt64 = 0
}

struct UserDefaultDefine {
    static let tabBarSelectedIndex = "tabBarSelectedIndex"
}

struct NotificationUserInfoDefine {

    static let currentLocation = "currentLocation"
}
