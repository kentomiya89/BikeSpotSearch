//
//  ResponseStatus.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/04.
//

import Foundation

struct ResultStatus: Decodable {
    let status: Status

    enum Status: String, Decodable {
        case success = "OK"
        case notFound = "ZERO_RESULTS"
        case overQuery = "OVER_QUERY_LIMIT"
        case requestDeny = "REQUEST_DENIED"
        case invalidRequest = "INVALID_REQUEST"
        case unknown = "UNKNOWN_ERROR"
    }
}
