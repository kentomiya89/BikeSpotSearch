//
//  ViewController.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/02.
//

import UIKit
import GoogleMaps
import PKHUD

class TopMapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView! {
        didSet {
            mapView.isMyLocationEnabled = true
            mapView.settings.compassButton = true
            mapView.settings.myLocationButton = true
            mapView.delegate = self
        }
    }

    @IBOutlet weak var reSearchButton: UIButton! {
        didSet {
            reSearchButton.isHidden = true
            reSearchButton.layer.cornerRadius = 7.0
            reSearchButton.layer.borderColor = UIColor.black.cgColor
            reSearchButton.layer.borderWidth = 1.0
        }
    }

    private var presenter: TopMapPresenterInput!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = TopMapPresenter(view: self)
        presenter.viewDidLoad()

    }

    @IBAction func reSearchBikeSpot(_ sender: Any) {
        // ローディング表示
        HUD.show(.progress)
        let coordinate = mapView.projection.coordinate(for: mapView.center)
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        presenter.reSeacrhBikeSpot(location)
    }

}

extension TopMapViewController: TopMapPresenterOutPut {

    private func failAlert(_ message: String) -> UIAlertController {
        let alertController =
                    UIAlertController(title: "",
                                      message: message,
                              preferredStyle: .alert)

        let okAction = UIAlertAction(title: L10n.ok,
                                     style: .default,
                                     handler: nil)
        alertController.addAction(okAction)
        return alertController
    }

    func showCurrentLocation(_ location: CLLocation) {
        mapView.camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  zoom: Float(LocationRelateNumber.zoomValue))
    }

    func showBikeParking(_ bikeParkMarkers: [GMSMarker]) {
        // ローディングを消す
        HUD.hide()
        bikeParkMarkers.map { $0.map = mapView }
    }

    func showFailBikeSpotAlert(_ message: String) {
        // ローディングを消す
        HUD.hide()
        present(failAlert(message), animated: true, completion: nil)
    }

    func clearAllMarkerOnMap() {
        mapView.clear()
    }

    func hideReSearchButton() {
        reSearchButton.isHidden = true
    }
}

extension TopMapViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        // 表示
        reSearchButton.isHidden = false
        // ボタンを最前面へ
        mapView.bringSubviewToFront(reSearchButton)
    }
}
