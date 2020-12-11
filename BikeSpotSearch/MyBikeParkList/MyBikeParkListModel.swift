//
//  MyBikeParkListModel.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/09.
//

import Foundation

protocol MyBikeParkListModelInput {
    func fetchMyBikeParks() -> [MyBikePark]

    func removeMyBikePark(bikePark: MyBikePark)
}

class MyBikeParkListModel {
    private let myBikeParkAccessor = MyBikeParkAccessor()
}

extension MyBikeParkListModel: MyBikeParkListModelInput {
    func fetchMyBikeParks() -> [MyBikePark] {
        return myBikeParkAccessor.fetchAll()
    }

    func removeMyBikePark(bikePark: MyBikePark) {
        do {
            try myBikeParkAccessor.delete(bikePark)
            // 削除したことを通知する
            NotificationCenter.default.post(name: .removeMyBikePark, object: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
}
