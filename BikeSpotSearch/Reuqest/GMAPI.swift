//
//  GMAPI.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/04.
//

import Foundation

final class GMAPI {

    struct PlaceSearch: GMRequest {

        typealias Response = BikeSpot

        var path: String {
            return "/place/textsearch/json"
        }

        var queryParameters: [URLQueryItem] {
            return [URLQueryItem(name: "key", value: APIKeyManager().getValue(key: "GoogleMapKey") as? String),
                    URLQueryItem(name: "query", value: "自動二輪駐輪場"),
                    URLQueryItem(name: "language", value: "ja"),
                    URLQueryItem(name: "range", value: String(LocationRelateNumber.searchRange))]
        }
    }
}
