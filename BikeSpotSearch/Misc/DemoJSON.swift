//
//  DemoJSON.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/05.
//

import Foundation

struct DemoJSON {

    private let bikeParkJsonPath = Bundle.main.path(forResource: "bike_park", ofType: "json")
    private let bikeShopJsonPath = Bundle.main.path(forResource: "bike_shop", ofType: "json")

    func getBikeParkJSON() -> Data? {
        return getData(bikeParkJsonPath!)
    }

    func getBikeShopJSON() -> Data? {
        return getData(bikeShopJsonPath!)
    }

    private func getData(_ path: String) -> Data? {
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return data
    }
}
