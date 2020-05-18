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

    enum MarketsAPIClientError: Error {
        case badURLComponents
    }

    enum Path: String {
        case nearbyMarkets = "locSearch"
    }

    enum QueryParams: String {
        case latitude = "lat"
        case longitude = "lng"
    }

    private let baseURL = URL(string: "http://search.ams.usda.gov/farmersmarkets/v1/data.svc/")!
    private let apiClient: APIClient

    public init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func requestMarkets(nearby location: Location) -> AnyPublisher<MarketsResponse, Error> {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(Path.nearbyMarkets.rawValue), resolvingAgainstBaseURL: true) else {
            return Fail(outputType: MarketsResponse.self, failure: MarketsAPIClientError.badURLComponents).eraseToAnyPublisher()
        }

        components.queryItems = [
            URLQueryItem(name: QueryParams.latitude.rawValue, value: String(location.latitude)),
            URLQueryItem(name: QueryParams.longitude.rawValue, value: String(location.longitude)),
        ]

        guard let url = components.url else {
            return Fail(outputType: MarketsResponse.self, failure: MarketsAPIClientError.badURLComponents).eraseToAnyPublisher()
        }

        let request = URLRequest(url: url)

        return apiClient.run(request)
            .eraseToAnyPublisher()
    }

}
