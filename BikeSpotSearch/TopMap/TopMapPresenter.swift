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
    }
}
