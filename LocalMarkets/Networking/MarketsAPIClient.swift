//
//  MarketsAPIClient.swift
//  LocalMarkets
//
//  Created by Michael Koch on 5/17/20.
//  Copyright © 2020 Michael Koch. All rights reserved.
//

import Foundation
import Combine

struct MarketsResponse: Codable {
    var markets: [Market]

    enum CodingKeys: String, CodingKey {
        case markets = "results"
    }
}

struct MarketsAPIClient {

    static func requestMarkets() -> AnyPublisher<MarketsResponse, Error> {
        let request: URLRequest = URLRequest(url: URL(string: "http://search.ams.usda.gov/farmersmarkets/v1/data.svc/locSearch?lat=37.509280&lng=-122.303370")!)

        return APIClient.run(request)
            .eraseToAnyPublisher()
    }

}
