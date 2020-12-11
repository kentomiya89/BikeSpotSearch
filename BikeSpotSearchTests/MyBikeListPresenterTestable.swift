//
//  MyBikeListPresenterTestable.swift
//  BikeSpotSearchTests
//
//  Created by kentomiyabayashi on 2020/12/11.
//

import Foundation
@testable import BikeSpotSearch

class MyBikeListPresenterSpy: MyBikeParkListPresenterOutput {
    private(set) var countOfInvokingUpdateMyBikeParks: Int = 0
    private(set) var countOfInvokingshowNoMyBikeParkMessage: Int = 0
    private(set) var countOfInvokinghideNoMyBikeParkMessage: Int = 0
    
    func updateMyBikePark() {
        countOfInvokingUpdateMyBikeParks += 1
    }
    
    func showNoMyBikeParkMessage() {
        countOfInvokingshowNoMyBikeParkMessage += 1
    }
    
    func hideNoMyBikeParkMessage() {
        countOfInvokinghideNoMyBikeParkMessage += 1
    }
}

class MyBikeListPresenterStub: MyBikeParkListModelInput {
    
    private var myBikeParksForFetchMethod: [MyBikePark] = []
    
    func addMyBikeParkForFetch(mybikeParks: MyBikePark) {
        myBikeParksForFetchMethod.append(mybikeParks)
    }

    func fetchMyBikeParks() -> [MyBikePark] {
        return myBikeParksForFetchMethod
    }
    
    func removeMyBikePark(bikePark: MyBikePark) {
        let index = myBikeParksForFetchMethod.firstIndex(of: bikePark)
        myBikeParksForFetchMethod.remove(at: index!)
    }

}
