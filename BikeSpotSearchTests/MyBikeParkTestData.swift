//
//  MyBikeParkMock.swift
//  BikeSpotSearchTests
//
//  Created by kentomiyabayashi on 2020/12/11.
//

import Foundation
@testable import BikeSpotSearch

extension MyBikePark {
    
    var shinjyuku: MyBikePark {
        let mock = MyBikePark()
        mock.bikeSpotId = 1
        mock.lat = 35.690921
        mock.lon = 139.70025799999996
        mock.name = "新宿"
        return mock
    }

    var shibuya: MyBikePark {
        let mock = MyBikePark()
        mock.bikeSpotId = 2
        mock.lat = 35.6598003
        mock.lon = 139.7023894
        mock.name = "渋谷"
        return mock
    }
}
