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
