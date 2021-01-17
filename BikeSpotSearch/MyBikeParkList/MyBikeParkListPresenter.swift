//
//  MyBikeParkListPresenter.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/09.
//

import Foundation

protocol MyBikeParkListPresenterInput {
    func viewWillAppear()
    var myBikeParksCount: Int { get }
    func myBikePark(forRow row: Int) -> MyBikePark?
    func removeMyBikePark(forRow row: Int)
}

protocol MyBikeParkListPresenterOutput: AnyObject {
    func updateMyBikePark()
    func showNoMyBikeParkMessage()
    func hideNoMyBikeParkMessage()
}

class MyBikeParkListPresenter {
    private var myBikeParks: [MyBikePark] = []
    private weak var view: MyBikeParkListPresenterOutput!
    private var model: MyBikeParkListModelInput

    init(view: MyBikeParkListPresenterOutput, model: MyBikeParkListModelInput) {
        self.view = view
        self.model = model
    }
}

extension MyBikeParkListPresenter: MyBikeParkListPresenterInput {

    func viewWillAppear() {
//        myBikeParks = model.fetchMyBikeParks()
        view.updateMyBikePark()
        determineMessageView()
    }

    var myBikeParksCount: Int {
        return myBikeParks.count
    }

    func myBikePark(forRow row: Int) -> MyBikePark? {
        guard row < myBikeParks.count  else { return nil }
        return myBikeParks[row]
    }

    func removeMyBikePark(forRow row: Int) {
        let removeBikePark = myBikeParks[row]
        myBikeParks.remove(at: row)
        model.removeMyBikePark(bikePark: removeBikePark)
        view.updateMyBikePark()
        determineMessageView()
    }

    private func determineMessageView() {
        if myBikeParks.count != 0 {
            view.hideNoMyBikeParkMessage()
        } else {
            view.showNoMyBikeParkMessage()
        }
    }
}
