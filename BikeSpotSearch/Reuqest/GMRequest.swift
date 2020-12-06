//
//  GMRequest.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/04.
//

import Foundation
import Alamofire

protocol GMRequest: URLRequestConvertible {
    associatedtype Response: Decodable
    var baseURL: URL { get }
    var path: String { get }
    var headers: [String: String] { get }
    var queryParameters: [URLQueryItem] { get }
}

extension GMRequest {

    var baseURL: URL {
        return URL(string: "https://maps.googleapis.com/maps/api")!
    }

    var headers: [String: String] {
        return ["Accept": "application/json"]
    }

    func asURLRequest() throws -> URLRequest {
        let pathURL = baseURL.appendingPathComponent(path)
        var urlComponent = URLComponents(url: pathURL, resolvingAgainstBaseURL: true)
        urlComponent?.queryItems = queryParameters

        let requestURL = urlComponent?.url
        var request = URLRequest(url: requestURL!)

        request.method = .get
        request.headers = HTTPHeaders(headers)

        return request
    }

}
