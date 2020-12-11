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
    // My駐輪場を追加
    func addMyBikeParkDB(_ name: String, _ coordinate: CLLocationCoordinate2D)
    // My駐輪場を取得
    func fetchMyBikeParks() -> [MyBikePark]
}

class TopMapModel {
    let myBikeParkAccessor = MyBikeParkAccessor()
}

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
                    print("駐輪場のリクエストエラー")
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
                    print("バイク屋のリクエストエラー")
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

    func addMyBikeParkDB(_ name: String, _ coordinate: CLLocationCoordinate2D) {
        let myBikePark = MyBikePark()
        myBikePark.name = name
        // IDを登録順番に振っていく
        myBikePark.bikeSpotId = myBikeParkAccessor.myBikeParkCount() + 1
        myBikePark.lat = coordinate.latitude
        myBikePark.lon = coordinate.longitude

        do {
            try myBikeParkAccessor.add(myBikePark)
        } catch {
            print(error.localizedDescription)
        }
    }

    func fetchMyBikeParks() -> [MyBikePark] {
        return myBikeParkAccessor.fetchAll()
    }
}
