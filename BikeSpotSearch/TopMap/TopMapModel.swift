//
//  TopMapModel.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/04.
//

import Foundation
import Alamofire
import CoreLocation

protocol TopMapModelOutput {
    // バイクスポット取得するメソッド
    func fetchBikeSpot(_ location: CLLocation, completion: @escaping ([PlaceSearchType: [PlaceResult]]?) -> Void)
    // 内部のjsonデータのデモを動かす用
    func getBikeSpotFromJSONData(_ location: CLLocation, completion: @escaping ([PlaceSearchType: [PlaceResult]]?) -> Void)
}

class TopMapModel {}

extension TopMapModel: TopMapModelOutput {
    func fetchBikeSpot(_ location: CLLocation, completion: @escaping ([PlaceSearchType: [PlaceResult]]?) -> Void) {

        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "queue", attributes: .concurrent)

        let requestBikePark = GMAPI.PlaceSearch(bikeSpotType: .bikePark, location: location)

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

        let requestBikeShop = GMAPI.PlaceSearch(bikeSpotType: .bikeShop, location: location)
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

            let bikeParkResult = [PlaceSearchType.bikePark: bikePark.results]
            let bikeShopResult = [PlaceSearchType.bikeShop: bikeShop.results]
            let result = bikeParkResult.union(bikeShopResult)
            completion(result)
        }
    }

    // 内部のjsonデータ取得用
    func getBikeSpotFromJSONData(_ location: CLLocation, completion: @escaping ([PlaceSearchType: [PlaceResult]]?) -> Void) {
        guard let bikeParkJSON = DemoJSON().getBikeParkJSON() else { return }
        guard let bikeShopJSON = DemoJSON().getBikeShopJSON() else { return }

        do {
            let bikePark = try JSONDecoder().decode(BikeSpot.self, from: bikeParkJSON)
            let bikeShop = try JSONDecoder().decode(BikeSpot.self, from: bikeShopJSON)

            let bikeParkResult = [PlaceSearchType.bikePark: bikePark.results]
            let bikeShopResult = [PlaceSearchType.bikeShop: bikeShop.results]
            let result = bikeParkResult.union(bikeShopResult)
            completion(result)
        } catch {
            print(error)
            completion(nil)
        }
    }

}
