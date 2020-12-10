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
    let photoReference: [String]? // ない時がある
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

    enum PhotoKeys: String, CodingKey {
        case photoReference = "photo_reference"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: ResultKeys.self)
        name = try values.decode(String.self, forKey: .name)
        placeID = try values.decode(String.self, forKey: .placeId)

        // 値がない場合はデータがない
        if let openValue = try? values.nestedContainer(keyedBy: OpeningKey.self, forKey: .openingHours) {
            openingNow = try openValue.decode(Bool.self, forKey: .openNow)
        } else {
            openingNow = nil
        }

        let geometry = try values.nestedContainer(keyedBy: GeoKey.self, forKey: .geometry)
        let locationValue = try geometry.nestedContainer(keyedBy: LocationKeys.self, forKey: .location)
        lat = try locationValue.decode(Double.self, forKey: .lat)
        lng = try locationValue.decode(Double.self, forKey: .lng)

        if var photos = try? values.nestedUnkeyedContainer(forKey: .photos) {
            var referenseArray: [String] = []

            while !photos.isAtEnd {
                let photoValues = try photos.nestedContainer(keyedBy: PhotoKeys.self)
                let referense = try photoValues.decode(String.self, forKey: .photoReference)
                referenseArray.append(referense)
            }
            photoReference = referenseArray
        } else {
            photoReference = nil
        }
    }
}
