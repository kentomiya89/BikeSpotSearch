//
//  APIKeyManager.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/02.
//

import Foundation

struct APIKeyManager {

    private let keyFilePath = Bundle.main.path(forResource: "apiKey", ofType: "plist")

    func getKeys() -> NSDictionary? {
        guard let keyFilePath = keyFilePath else { return nil }
        return NSDictionary(contentsOfFile: keyFilePath)
    }

    func getValue(key: String) -> AnyObject? {
        guard let keys = getKeys() else { return nil }
        return keys[key]! as AnyObject
    }
}
