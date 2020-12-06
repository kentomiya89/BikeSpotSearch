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

    private func requestLocation() {
        #if DEMO
        model.getBikeSpotFromJSONData { [weak self] (result) in
            print(result)
            guard let result = result else { return }
            self?.makeMarkers(result)
        }
        #else
        model.fetchBikeSpot { [weak self] (result) in
            switch result {
            case .success(let response):
                print(response)
                self?.makeMarkers(response)
            case .failure:
            print("失敗した")
            }
        }
        #endif
    }

    // アイコンを生成する
    private func makeMarkers(_ bikeSpot: BikeSpot) {

        let markerArray: [GMSMarker] = bikeSpot.results.map {
            let position = CLLocationCoordinate2DMake($0.lat, $0.lng)
            let marker = GMSMarker(position: position)
            marker.icon = UIImage(named: "BikePark")
            marker.title = $0.name
            marker.snippet = "適当"
            return marker
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

        requestLocation()
        view.showCurrentLocation(location)
    }

}
