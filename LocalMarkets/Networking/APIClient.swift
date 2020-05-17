//
//  APIClient.swift
//  LocalMarkets
//
//  Created by Michael Koch on 5/17/20.
//  Copyright © 2020 Michael Koch. All rights reserved.
//

import Foundation
import Combine

struct APIClient {

    enum APIClientError: Error {
        case badResponse(_ response: URLResponse)
        case statusCode(_ code: Int)
    }

    static func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: request)
            .retry(2)
            .tryMap { result in
                guard let response = result.response as? HTTPURLResponse else {
                    throw APIClientError.badResponse(result.response)
                }
                guard response.statusCode == 200 else {
                    throw APIClientError.statusCode(response.statusCode)
                }
                return result.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

}
