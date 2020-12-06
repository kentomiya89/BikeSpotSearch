//
//  GMAPIClinet.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/04.
//

import Foundation
import Alamofire

enum GMClientError: Error {
    case failedToCreateURLRequest
    case failedConnection
    case noData
    case failedParse
    case statusError(ResultStatus)
}

struct GMAPIClinet {

    // MARK: TODO ネストが深いのをいい感じに綺麗にしたい
    func send<Request: GMRequest>(_ request: Request, completion: @escaping (Result<Request.Response, GMClientError>) -> Void) {
        do {
            let urlRequest = try request.asURLRequest()

            AF.request(urlRequest).responseJSON { result in
                guard let data = result.data else {
                    completion(.failure(.noData))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    // レスポンスパラメータにステータスを示すものがあるので
                    // 先にそのパラメータを解析してステータスを見る
                    let resultStatus = try decoder.decode(ResultStatus.self, from: data)
                    switch resultStatus.status {
                    case .success:
                        let response = try decoder.decode(Request.Response.self, from: data)
                        completion(.success(response))
                    default:
                        completion(.failure(.statusError(resultStatus)))
                    }
                } catch {
                    print(error)
                    completion(.failure(.failedParse))
                }
            }
        } catch {
            completion(.failure(.failedToCreateURLRequest))
        }

    }

}
