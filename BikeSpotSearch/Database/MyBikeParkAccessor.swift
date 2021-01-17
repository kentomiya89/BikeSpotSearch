//
//  MyBikeParkAccessor.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/09.
//

import Foundation
import RealmSwift

struct MyBikeParkAccessor {
    private let realm = try! Realm()

    func add(_ bikePark: MyBikePark) throws {

        try realm.write {
            realm.add(bikePark)
        }
    }

    func delete(_ bikePark: MyBikePark) throws {
        try realm.write {
            realm.delete(bikePark)
        }
    }

    func fetchAll() -> [MyBikePark] {
        return Array(realm.objects(MyBikePark.self))
    }

    func fetchResults() -> Results<MyBikePark> {
        return realm.objects(MyBikePark.self)
    }

    func myBikeParkCount() -> Int {
        let result = realm.objects(MyBikePark.self)
        return result.count
    }
}
