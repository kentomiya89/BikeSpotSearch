//
//  MyBikeParkListViewModel.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2021/01/04.
//

import Foundation
import RxSwift
import RxCocoa
import RxRealm
import RxDataSources

final class MyBikeParkListViewModel {

    let noBikeSpotViewIsHidden = BehaviorRelay<Bool>(value: false)
    private let disposebag = DisposeBag()

    var bikeParkSection: Observable<[BikeParkSectionModel]>
//    var myBikeParks = BehaviorRelay<[MyBikePark]>(value: [])

    init(itemDeleted: Observable<IndexPath>, model: MyBikeParkListModelInput) {
        let bikeParks = model.fetchMyBikeParks()
        bikeParkSection = bikeParks.map { [BikeParkSectionModel(items: $0)] }

        // 追加
        bikeParks.subscribe { [weak self] myBikePark in
            self?.noBikeSpotViewIsHidden.accept(myBikePark.event.element?.count != 0)
        }.disposed(by: disposebag)

        // 削除
        itemDeleted.subscribe { event in
            // 保留
//            let row = event.event.element?.row
//            model.removeMyBikePark(bikePark: )
        }.disposed(by: disposebag)
    }
}

struct BikeParkSectionModel {
    var items: [Item]
}

extension BikeParkSectionModel: AnimatableSectionModelType {
    var identity: String {
        return TableViewCellIdentifier.myBikeParkSection
    }

    typealias Identity = String

    typealias Item = MyBikePark

    init(original: BikeParkSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

extension MyBikePark: IdentifiableType {
    typealias Identity = Int

    var identity: Int {
        return bikeSpotId
    }
}
