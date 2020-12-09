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
            reSearchButton.layer.borderWidth = 0.7
        }
    }

    private var presenter: TopMapPresenterInput!

    // 追加用のアラート
    var addMyBikeParkAlert: UIAlertController {
        let alert = UIAlertController(title: nil,
                                      message: L10n.addMyBicycleParkingToThisPosition,
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: L10n.cancel,
                                         style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        alert.addTextField { (text) in
            text.placeholder = L10n.pleaseInputParkName
        }

        return alert
    }

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

    func showMyBikeParkEditAlert(_ coordinate: CLLocationCoordinate2D) {
        present(makeMyBikeParkEditAlert(coordinate), animated: true, completion: nil)
    }

    private func makeMyBikeParkEditAlert(_ coordinate: CLLocationCoordinate2D) -> UIAlertController {
        let alert = addMyBikeParkAlert
        let okAction = UIAlertAction(title: L10n.ok,
                                   style: .default) { [weak self] _ in
            guard let textFields = alert.textFields,
                  let text = textFields.first?.text else { return }

            let marker = GMSMarker(position: coordinate)
            marker.title = text
            marker.userData = L10n.myBikePark
            marker.map = self?.mapView
            self?.presenter.addMyBikeParkDB(text, coordinate)
        }
        okAction.isEnabled = false

        let textField = alert.textFields?.first
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification,
                                               object: textField,
                                               queue: OperationQueue.main) {_ in
            let textCount = textField?.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
            let isTextNotEmpty = textCount > 0
            // アラートテキストの入力に応じてOKボタンを有効にするか変更
            okAction.isEnabled = isTextNotEmpty
        }
        alert.addAction(okAction)

        return alert
    }

}

extension TopMapViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        // 表示
        reSearchButton.isHidden = false
        reSearchButton.layer.borderColor = UIColor.black.cgColor
        reSearchButton.layer.borderWidth = 0.7

        // ボタンを最前面へ
        mapView.bringSubviewToFront(reSearchButton)
    }

    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        presenter.didLongPress(coordinate: coordinate)
    }
}
