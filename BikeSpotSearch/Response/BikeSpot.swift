//
//  PlaceResponse.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/04.
//

import Foundation

struct BikeSpot: Decodable {
    let results: [PlaceResult]

    enum CodingKeys: String, CodingKey {
        case results
    }

    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        results = try value.decode([PlaceResult].self, forKey: .results)
    }
}

struct PlaceResult: Decodable {
    let name: String
    let lat: Double
    let lng: Double
    let placeID: String
    let openingNow: Bool?

    enum ResultKeys: String, CodingKey {
        case geometry
        case name
        case photos = "photos"
        case placeId = "place_id"
        case openingHours = "opening_hours"
    }

    enum GeoKey: String, CodingKey {
        case location
    }

    enum LocationKeys: String, CodingKey {
        case lat
        case lng
    }

    enum OpeningKey: String, CodingKey {
        case openNow = "open_now"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: ResultKeys.self)
        name = try values.decode(String.self, forKey: .name)
        placeID = try values.decode(String.self, forKey: .placeId)

        // 値がない場合はデータがない
        if let openValue = try? values.nestedContainer(keyedBy: OpeningKey.self, forKey: .openingHours) {
            openingNow = try openValue.decodeIfPresent(Bool.self, forKey: .openNow)
        } else {
            openingNow = nil
        }

        let geometry = try values.nestedContainer(keyedBy: GeoKey.self, forKey: .geometry)
        let locationValue = try geometry.nestedContainer(keyedBy: LocationKeys.self, forKey: .location)
        lat = try locationValue.decode(Double.self, forKey: .lat)
        lng = try locationValue.decode(Double.self, forKey: .lng)
    }
}
