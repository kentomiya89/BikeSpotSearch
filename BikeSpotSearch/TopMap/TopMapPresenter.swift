//
//  TopMapPresenter.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/03.
//

import Foundation

protocol TopMapPresenterInput {

    func viewDidLoad()
}

protocol TopMapPresenterOutPut: AnyObject {

}

class TopMapPresenter {

    private weak var view: TopMapPresenterOutPut!
    private var model: TopMapModelOutput

    init(view: TopMapPresenterOutPut) {
        self.view = view
        self.model = TopMapModel()
    }
}

extension TopMapPresenter: TopMapPresenterInput {

    func viewDidLoad() {

        #if DEMO
        model.getBikeSpotFromJSONData { (result) in
            print(result)
        }
        #else
        model.fetchBikeSpot { (result) in
            switch result {
            case .success(let response):
                print(response)
            case .failure:
            print("失敗した")
            }
        }
        #endif
    }
}
