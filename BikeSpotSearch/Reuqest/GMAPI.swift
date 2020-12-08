//
//  GMAPI.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/04.
//

import Foundation
import CoreLocation

final class GMAPI {

    struct PlaceSearch: GMRequest {

        typealias Response = BikeSpot

        var bikeSpotType: PlaceSearchType
        var location: CLLocation

        var path: String {
            return "/place/textsearch/json"
        }

        var locationQueryStr: String {
            return String(location.coordinate.latitude) + "," + String(location.coordinate.longitude)
        }

        var queryParameters: [URLQueryItem] {

            return [URLQueryItem(name: "key", value: APIKeyManager().getValue(key: "GoogleMapKey") as? String),
                    URLQueryItem(name: "query", value: bikeSpotType.rawValue),
                    URLQueryItem(name: "language", value: "ja"),
                    URLQueryItem(name: "range", value: String(LocationRelateNumber.searchRange)),
                    URLQueryItem(name: "location", value: locationQueryStr)]
        }
    }
}
