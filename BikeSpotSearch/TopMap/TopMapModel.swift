//
//  TopMapModel.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/04.
//

import Foundation
import Alamofire

protocol TopMapModelOutput {
    // バイクスポット取得するメソッド
    func fetchBikeSpot(completion: @escaping (Result<BikeSpot, Error>) -> Void)
    // 内部のjsonデータのデモを動かす用
    func getBikeSpotFromJSONData(completion: @escaping (BikeSpot?) -> Void)
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

    // 内部のjsonデータ取得用
    func getBikeSpotFromJSONData(completion: @escaping (BikeSpot?) -> Void) {
        guard let jsonData = DemoJSON().getPlaceSearchJSON() else { return }
        do {
            let bikeSpot = try JSONDecoder().decode(BikeSpot.self, from: jsonData)
            completion(bikeSpot)
        } catch {
            print(error)
            completion(nil)
        }
    }

}
