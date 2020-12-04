//
//  TopMapModel.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/04.
//

import Foundation
import Alamofire

protocol TopMapModelOutput {
    func fetchBikeSpot(completion: @escaping (Result<BikeSpot, Error>) -> Void)
}

class TopMapModel {}

extension TopMapModel: TopMapModelOutput {
    func fetchBikeSpot(completion: @escaping (Result<BikeSpot, Error>) -> Void) {
        let request = GMAPI.PlaceSearch()

        GMAPIClinet().send(request) { (result) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
