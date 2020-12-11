//
//  BikeSpotSearchTests.swift
//  BikeSpotSearchTests
//
//  Created by kentomiyabayashi on 2020/12/02.
//

import XCTest
@testable import BikeSpotSearch

class BikeSpotSearchTests: XCTestCase {
    
    let accessor = MyBikeParkAccessor()

    override func setUp() {
        super.setUp()
        clearMyBikePark()
    }

    func clearMyBikePark() {
        let myBikeParkArray = accessor.fetchAll()
        myBikeParkArray.map {
            try! accessor.delete($0)
        }
    }

    func testRealmAddAndDeleteTest() throws {
        try XCTContext.runActivity(named: "データの保存削除のテスト") { _ in
            let shinjyuku = MyBikePark().shinjyuku
            try accessor.add(shinjyuku)
            // 1個
            XCTAssertEqual(accessor.myBikeParkCount(), 1)
            
            let shibuya = MyBikePark().shibuya
            try accessor.add(shibuya)
            // 2個
            XCTAssertEqual(accessor.myBikeParkCount(), 2)
            
            try accessor.delete(shinjyuku)
            try accessor.delete(shibuya)
            // 0個
            XCTAssertEqual(accessor.myBikeParkCount(), 0)
        }
    }
    
    func testMyParkList() {
        XCTContext.runActivity(named: "My駐輪場一覧画面の表示") { _ in
            XCTContext.runActivity(named: "My駐輪場データがない初期表示の振る舞い") { _ in
                let spy = MyBikeListPresenterSpy()
                let stub = MyBikeListPresenterStub()
                let presenter = MyBikeParkListPresenter(view: spy, model: stub)
                presenter.viewWillAppear()

                // updateメソッドが一回だけ呼ばれる
                XCTAssertEqual(spy.countOfInvokingUpdateMyBikeParks, 1)
                // ない時のメッセージを出す
                XCTAssertEqual(spy.countOfInvokingshowNoMyBikeParkMessage, 1)
                // データが0
                XCTAssertEqual(presenter.myBikeParksCount, 0)
            }
            XCTContext.runActivity(named: "My駐輪場データがあり、その後削除したときの振る舞い") { _ in
                let spy = MyBikeListPresenterSpy()
                let stub = MyBikeListPresenterStub()
                let presenter = MyBikeParkListPresenter(view: spy, model: stub)

                let shinjyuku = MyBikePark().shinjyuku
                stub.addMyBikeParkForFetch(mybikeParks: shinjyuku)
                presenter.viewWillAppear()
                
                // updateメソッドが一回目呼ばれる
                XCTAssertEqual(spy.countOfInvokingUpdateMyBikeParks, 1)
                // ない時のメッセージを出す
                XCTAssertEqual(spy.countOfInvokinghideNoMyBikeParkMessage, 1)
                // データが0
                XCTAssertEqual(presenter.myBikeParksCount, 1)

                // 一つしか入れていないので
                presenter.removeMyBikePark(forRow: 0)
                
                // updateメソッドが一回目呼ばれる
                XCTAssertEqual(spy.countOfInvokingUpdateMyBikeParks, 2)
                // ない時のメッセージを出す
                XCTAssertEqual(spy.countOfInvokingshowNoMyBikeParkMessage, 1)
                // データが0
                XCTAssertEqual(presenter.myBikeParksCount, 0)
            }
        }
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
