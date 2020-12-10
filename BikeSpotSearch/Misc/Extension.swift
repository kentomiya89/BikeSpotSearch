//
//  Extension.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/08.
//

import Foundation

public extension Dictionary {
    func union(_ other: Dictionary) -> Dictionary {
        var tmp = self
        other.forEach { tmp[$0.0] = $0.1 }
        return tmp
    }
}

extension Notification.Name {
    static let removeMyBikePark = Notification.Name("removeMyBikePark")
}
