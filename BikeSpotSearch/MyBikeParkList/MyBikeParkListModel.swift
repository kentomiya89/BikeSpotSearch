//
//  MyBikeParkListModel.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/09.
//

import Foundation

protocol MyBikeParkListModelOutput {
    func fetchMyBikeParks() -> [MyBikePark]

    func removeMyBikePark(bikePark: MyBikePark)
}

class MyBikeParkListModel {
    private let myBikeParkAccessor = MyBikeParkAccessor()
}

extension MyBikeParkListModel: MyBikeParkListModelOutput {
    func fetchMyBikeParks() -> [MyBikePark] {
        return myBikeParkAccessor.fetchAll()
    }

    func removeMyBikePark(bikePark: MyBikePark) {
        do {
            try myBikeParkAccessor.delete(bikePark)
        } catch {
            print(error.localizedDescription)
        }
    }
}
