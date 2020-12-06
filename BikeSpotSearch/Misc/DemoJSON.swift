//
//  DemoJSON.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/05.
//

import Foundation

struct DemoJSON {

    private let placeSearchPath = Bundle.main.path(forResource: "place_search", ofType: "json")

    func getPlaceSearchJSON() -> Data? {
        return getData(placeSearchPath!)
    }

    private func getData(_ path: String) -> Data? {
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return data
    }
}
