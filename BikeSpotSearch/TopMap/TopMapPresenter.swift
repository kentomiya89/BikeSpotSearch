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
    func didLongPress(coordinate: CLLocationCoordinate2D)
    func addMyBikeParkDB(_ name: String, _ coordinate: CLLocationCoordinate2D)
    func infoViewInTextColor(snippet: String) -> UIColor
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
    // 追加する
    func showMyBikeParkEditAlert(_ coordinate: CLLocationCoordinate2D)
}

class TopMapPresenter {

    private weak var view: TopMapPresenterOutPut!
    private var model: TopMapModelInput
    private var didShowCurrent: Bool = false
    private var myBikeParkMarkerArray: [GMSMarker] = []
    private var bikeSpotMarkerArray: [GMSMarker] = []

    init(view: TopMapPresenterOutPut, model: TopMapModelInput) {
        self.view = view
        self.model = model
    }

}

extension TopMapPresenter: TopMapPresenterInput {

    // MARK: プロトコルメソッド
    func viewDidLoad() {
        Radar.shared.start()

        // マーカーのリフレッシュ
        NotificationCenter.default.addObserver(self, selector: #selector(refreshMarkerData), name: .removeMyBikePark, object: nil)

        // 現在位置の更新
        NotificationCenter.default.addObserver(self, selector: #selector(currentLocation(notication:)), name: .currentLocation, object: nil)
    }

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

    func didLongPress(coordinate: CLLocationCoordinate2D) {
        view.showMyBikeParkEditAlert(coordinate)
    }

    func addMyBikeParkDB(_ name: String, _ coordinate: CLLocationCoordinate2D) {
        model.addMyBikeParkDB(name, coordinate)
    }

    func infoViewInTextColor(snippet: String) -> UIColor {
        if snippet == L10n.opening {
            return UIColor.blue
        } else if snippet == L10n.closing {
            return UIColor.red
        } else {
            return UIColor.black
        }
    }

    // MARK: プライベートメソッド
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
    private func makeMarkers(_ result: [PlaceSearchType: [PlaceResult]], _ current: CLLocation) {
        // MARK: TODO もっといいロジックが思いつけば書き直す

        guard let bikeParkResult = result[.bikePark],
              let bikeShopResult = result[.bikeShop] else {
            // バイク駐輪場・バイク屋どちらか片方しか取れてない場合も
            // エラーメッセージを表示する
            view.showFailBikeSpotAlert(L10n.canTGetBikeSpot)
            return
        }

        // 駐輪場
        let bikeParkArray: [GMSMarker] =  markerArray(bikeParkResult, current: current, type: .bikePark)
        // バイク屋
        let bikeShopArray: [GMSMarker] = markerArray(bikeShopResult, current: current, type: .bikeShop)
        let markerArray = bikeParkArray + bikeShopArray

        // 最寄りに候補が一つもなければ終了
        if markerArray.count == 0 {
            view.showFailBikeSpotAlert(L10n.notFoundBikeSpot)
            return
        }

        // バイクスポットマーカーを保存
        bikeSpotMarkerArray = markerArray

        // 新しく表示する前に古いマーカーを消す
        view.clearAllMarkerOnMap()

        showMyBikePark()
        // 再検索ボタンを非表示にする
        view.hideReSearchButton()
        view.showBikeParking(markerArray)
    }

    // マーカーの配列を作成する
    private func markerArray(_ placeResult: [PlaceResult], current: CLLocation, type: PlaceSearchType) -> [GMSMarker] {

        let markerArray: [GMSMarker] = placeResult.filter {
            let position = CLLocationCoordinate2DMake($0.lat, $0.lng)
            let point: CLLocation = CLLocation(latitude: position.latitude, longitude: position.longitude)

            return point.distance(from: current) <= LocationRelateNumber.searchRange
        }
        .map { place in
            let position = CLLocationCoordinate2DMake(place.lat, place.lng)
            let marker = GMSMarker(position: position)

            switch type {
            case .bikePark: marker.icon = Asset.bikePark.image
            case .bikeShop: marker.icon = Asset.bikeShop.image
            }

            if let openingNow = place.openingNow {
                marker.snippet = openingNow ? L10n.opening : L10n.closing
            } else {
                marker.snippet = L10n.unknown
            }

            marker.title = place.name

            return marker
        }

        return markerArray
    }

    private func showMyBikePark() {
        let marker = makeMyBikeParkMarker(model.fetchMyBikeParks())
        // My駐輪場を更新
        myBikeParkMarkerArray = marker
        view.showBikeParking(marker)
    }

    @objc private func refreshMarkerData() {
        // My駐輪場を更新
        myBikeParkMarkerArray = makeMyBikeParkMarker(model.fetchMyBikeParks())
        // 一度全てマーカーを削除
        view.clearAllMarkerOnMap()
        // My駐輪場を表示
        view.showBikeParking(myBikeParkMarkerArray)
        // バイク駐輪場とバイク屋を表示
        view.showBikeParking(bikeSpotMarkerArray)
    }

    private func makeMyBikeParkMarker(_ myBikeParkArray: [MyBikePark]) -> [GMSMarker] {
        let marker: [GMSMarker] = myBikeParkArray.map {
            let coordinate = CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lon)
            let marker = GMSMarker(position: coordinate)
            marker.title = $0.name
            return marker
        }
        return marker
    }
}

// MARK: Location
extension TopMapPresenter {

    @objc func currentLocation(notication: Notification) {

        guard let location = notication.userInfo?[NotificationUserInfoDefine.currentLocation] as? CLLocation else { return }

        // 既に現在地を表示していたら表示しない
        if didShowCurrent == true {
            return
        }
        didShowCurrent = true

        requestLocation(location)
        view.showCurrentLocation(location)
    }

}
