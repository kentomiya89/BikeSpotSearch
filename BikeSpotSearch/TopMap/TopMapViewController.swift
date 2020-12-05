//
//  ViewController.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/02.
//

import UIKit
import GoogleMaps

class TopMapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView! {
        didSet {
            mapView.isMyLocationEnabled = true
            mapView.settings.compassButton = true
            mapView.settings.myLocationButton = true
        }
    }

    private var presenter: TopMapPresenterInput!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = TopMapPresenter(view: self)
        presenter.viewDidLoad()
    }
}

extension TopMapViewController: TopMapPresenterOutPut {
    func showCurrentLocation(_ location: CLLocation) {
        mapView.camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  zoom: 13.0)
    }
}
