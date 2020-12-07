//
//  TopMapPresenter.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/03.
//

import Foundation
import CoreLocation
import GoogleMaps

protocol TopMapPresenterInput {
    func viewDidLoad()

}

protocol TopMapPresenterOutPut: AnyObject {
    // 現在地を表示する
    func showCurrentLocation(_ location: CLLocation)
    // バイク駐輪場を表示する
    func showBikeParking(_ bikeParkMarkers: [GMSMarker])
}

class TopMapPresenter {

    private weak var view: TopMapPresenterOutPut!
    private var model: TopMapModelOutput
    private var didShowCurrent: Bool = false

    init(view: TopMapPresenterOutPut) {
        self.view = view
        self.model = TopMapModel()
    }

}

extension TopMapPresenter: TopMapPresenterInput {

    func viewDidLoad() {
        Radar.shared.delegate = self
        Radar.shared.start()
    }

    private func requestLocation(_ current: CLLocation) {
        #if DEMO
        model.getBikeSpotFromJSONData { [weak self] (result) in
            // 取得失敗
            print(result)
            guard let result = result else { return }

            let bikePark = result[PlaceSearchType.bikePark.rawValue]!
            self?.makeMarkers(bikePark, current, .bikePark)

            let bikeShop = result[PlaceSearchType.bikeShop.rawValue]!
            self?.makeMarkers(bikeShop, current, .bikeShop)

        }
        #else
        model.fetchBikeSpot { [weak self] result in
            // 取得失敗
            guard let result = result else { return }

            let bikePark = result[PlaceSearchType.bikePark.rawValue]!
            self?.makeMarkers(bikePark, current, .bikePark)

            let bikeShop = result[PlaceSearchType.bikeShop.rawValue]!
            self?.makeMarkers(bikeShop, current, .bikeShop)
        }
        #endif
    }

    // アイコンを生成する
    private func makeMarkers(_ bikeSpot: BikeSpot, _ current: CLLocation, _ bikeSpotType: PlaceSearchType) {

        let markerArray: [GMSMarker] = bikeSpot.results.filter {
            let position = CLLocationCoordinate2DMake($0.lat, $0.lng)
            let point: CLLocation = CLLocation(latitude: position.latitude, longitude: position.longitude)

            return point.distance(from: current) <= LocationRelateNumber.searchRange
        }
        .map {
            let position = CLLocationCoordinate2DMake($0.lat, $0.lng)
            let marker = GMSMarker(position: position)
            switch bikeSpotType {
            case .bikePark: marker.icon = Asset.bikePark.image
            case .bikeShop: marker.icon = Asset.bikeShop.image
            }
            marker.title = $0.name
            return marker
        }

        // 最寄りに候補が一つもなければ終了
        if markerArray.count == 0 {
            return
        }

        view.showBikeParking(markerArray)
    }

}

extension TopMapPresenter: RaderDelgate {

    func currentLocation(location: CLLocation) {
        // 既に現在地を表示していたら表示しない
        if didShowCurrent == true {
            return
        }
        didShowCurrent = true

        requestLocation(location)
        view.showCurrentLocation(location)
    }

}
