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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
