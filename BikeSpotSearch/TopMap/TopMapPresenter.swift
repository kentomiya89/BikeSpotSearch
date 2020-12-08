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
    func reSeacrhBikeSpot(_ current: CLLocation)
}

protocol TopMapPresenterOutPut: AnyObject {
    // 現在地を表示する
    func showCurrentLocation(_ location: CLLocation)
    // バイク駐輪場を表示する
    func showBikeParking(_ bikeParkMarkers: [GMSMarker])
    // 取得失敗のアラートを表示
    func showFailBikeSpotAlert(_ message: String)
    // 地図のマーカーを全て消す
    func clearAllMarkerOnMap()
    // 再検索ボタンを非表示
    func hideReSearchButton()
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

    func reSeacrhBikeSpot(_ current: CLLocation) {
        #if DEMO
        model.getBikeSpotFromJSONData(current) { [weak self] (result) in
            // 取得失敗
            print(result)
            guard let result = result else {
                // 再検索の場合はエラーアラートを表示
                self?.view.showFailBikeSpotAlert(L10n.canTGetBikeSpot)
                return
            }
            self?.makeMarkers(result, current)
        }
        #else
        model.fetchBikeSpot(current) { [weak self] result in
            // 取得失敗
            guard let result = result else {
                // 再検索の場合はエラーアラートを表示
                self?.view.showFailBikeSpotAlert(L10n.canTGetBikeSpot)
                return
            }
            self?.makeMarkers(result, current)
        }
        #endif
    }

    func viewDidLoad() {
        Radar.shared.delegate = self
        Radar.shared.start()
    }

    private func requestLocation(_ current: CLLocation) {
        #if DEMO
        model.getBikeSpotFromJSONData(current) { [weak self] (result) in
            // 取得失敗
            print(result)
            guard let result = result else { return }
            self?.makeMarkers(result, current)

        }
        #else
        model.fetchBikeSpot(current) { [weak self] result in
            // 取得失敗
            guard let result = result else { return }
            self?.makeMarkers(result, current)
        }
        #endif
    }

    // アイコンを生成する
    private func makeMarkers(_ result: [PlaceSearchType: [PlaceResult]] , _ current: CLLocation) {
        // MARK: TODO もっといいロジックが思いつけば書き直す

        // 駐輪場
        let bikeParkArray: [GMSMarker] = result[.bikePark]!.filter {
            let position = CLLocationCoordinate2DMake($0.lat, $0.lng)
            let point: CLLocation = CLLocation(latitude: position.latitude, longitude: position.longitude)

            return point.distance(from: current) <= LocationRelateNumber.searchRange
        }
        .map { place in
            let position = CLLocationCoordinate2DMake(place.lat, place.lng)
            let marker = GMSMarker(position: position)
            marker.icon = Asset.bikePark.image
            marker.title = place.name

            return marker
        }
        
        // バイク屋
        let bikeShopArray: [GMSMarker] = result[.bikeShop]!.filter {
            let position = CLLocationCoordinate2DMake($0.lat, $0.lng)
            let point: CLLocation = CLLocation(latitude: position.latitude, longitude: position.longitude)

            return point.distance(from: current) <= LocationRelateNumber.searchRange
        }
        .map { place in
            let position = CLLocationCoordinate2DMake(place.lat, place.lng)
            let marker = GMSMarker(position: position)

            marker.icon = Asset.bikeShop.image
            marker.title = place.name

            return marker
        }

        let markerArray = bikeParkArray + bikeShopArray
        // 最寄りに候補が一つもなければ終了
        if markerArray.count == 0 {
            view.showFailBikeSpotAlert(L10n.notFoundBikeSpot)
            return
        }

        // 新しく表示する前に古いマーカーを消す
        view.clearAllMarkerOnMap()
        // 再検索ボタンを非表示にする
        view.hideReSearchButton()
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
