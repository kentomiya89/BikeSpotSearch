//
//  MyBikeParkListModel.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/09.
//

import Foundation
import RxSwift
import RealmSwift
import RxRealm

protocol MyBikeParkListModelInput {
    func fetchMyBikeParks() -> Observable<[MyBikePark]>
    func removeMyBikePark(bikePark: MyBikePark)
}

class MyBikeParkListModel {
    private let myBikeParkAccessor = MyBikeParkAccessor()
    private let disposebag = DisposeBag()
}

extension MyBikeParkListModel: MyBikeParkListModelInput {
    func fetchMyBikeParks() -> Observable<[MyBikePark]> {
        let mybikeParks = myBikeParkAccessor.fetchResults()
        return Observable.array(from: mybikeParks)
    }

    func removeMyBikePark(bikePark: MyBikePark) {

        Observable.from(object: bikePark)
            .subscribe(Realm.rx.delete())
            .disposed(by: disposebag)
        // TODO: 地図画面もMVVMにしたら消す
        // 削除したことを通知する
        NotificationCenter.default.post(name: .removeMyBikePark, object: nil)
    }
}
