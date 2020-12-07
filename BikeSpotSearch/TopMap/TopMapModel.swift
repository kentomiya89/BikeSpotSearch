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
    func fetchBikeSpot(completion: @escaping ([String: BikeSpot]?) -> Void)
    // 内部のjsonデータのデモを動かす用
    func getBikeSpotFromJSONData(completion: @escaping ([String: BikeSpot]?) -> Void)
}

class TopMapModel {}

extension TopMapModel: TopMapModelOutput {
    func fetchBikeSpot(completion: @escaping ([String: BikeSpot]?) -> Void) {

        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "queue", attributes: .concurrent)

        let requestBikePark = GMAPI.PlaceSearch(bikeSpotType: .bikePark)
        var bikePark: BikeSpot?

        // バイク駐輪場をリクエスト
        dispatchGroup.enter()
        dispatchQueue.async(group: dispatchGroup) {
            GMAPIClinet().send(requestBikePark) { (result) in
                switch result {
                case .success(let response):
                    bikePark = response
                    dispatchGroup.leave()
                case .failure(let error):
                    print(error)
                    dispatchGroup.leave()
                }
            }
        }

        let requestBikeShop = GMAPI.PlaceSearch(bikeSpotType: .bikeShop)
        var bikeShop: BikeSpot?

        // バイク屋をリクエスト
        dispatchGroup.enter()
        dispatchQueue.async(group: dispatchGroup) {
            GMAPIClinet().send(requestBikeShop) { (result) in
                switch result {
                case .success(let response):
                    bikeShop = response
                    dispatchGroup.leave()
                case .failure(let error):
                    print(error)
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            guard let bikePark = bikePark,
                  let bikeShop = bikeShop else {
                completion(nil)
                return
            }

            let result = [PlaceSearchType.bikePark.rawValue: bikePark,
                          PlaceSearchType.bikeShop.rawValue: bikeShop]
            completion(result)
        }
    }

    // 内部のjsonデータ取得用
    func getBikeSpotFromJSONData(completion: @escaping ([String: BikeSpot]?) -> Void) {
        guard let bikeParkJSON = DemoJSON().getBikeParkJSON() else { return }
        guard let bikeShopJSON = DemoJSON().getBikeShopJSON() else { return }

        do {
            let bikePark = try JSONDecoder().decode(BikeSpot.self, from: bikeParkJSON)
            let bikeShop = try JSONDecoder().decode(BikeSpot.self, from: bikeShopJSON)

            let result = [PlaceSearchType.bikePark.rawValue: bikePark,
                          PlaceSearchType.bikeShop.rawValue: bikeShop]
            completion(result)
        } catch {
            print(error)
            completion(nil)
        }
    }

}
