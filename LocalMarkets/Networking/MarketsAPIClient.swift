//
//  MarketsAPIClient.swift
//  LocalMarkets
//
//  Created by Michael Koch on 5/17/20.
//  Copyright © 2020 Michael Koch. All rights reserved.
//

import Foundation
import Combine

struct MarketsAPIClient {

    enum MarketsAPIClientError: Error {
        case badURLComponents
    }

    enum Path: String {
        case locationSearch = "locSearch"
        case zipSerach = "zipSearch"
        case marketDetail = "mktDetail"
    }

    enum QueryParams: String {
        case latitude = "lat"
        case longitude = "lng"
        case marketID = "id"
    }

    private let baseURL = URL(string: "http://search.ams.usda.gov/farmersmarkets/v1/data.svc/")!
    private let apiClient: APIClient

    public init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func requestMarkets(nearby location: Location) -> AnyPublisher<NearbyMarketsResponse, Error> {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(Path.locationSearch.rawValue), resolvingAgainstBaseURL: true) else {
            return Fail(outputType: NearbyMarketsResponse.self, failure: MarketsAPIClientError.badURLComponents).eraseToAnyPublisher()
        }

        components.queryItems = [
            URLQueryItem(name: QueryParams.latitude.rawValue, value: String(location.latitude)),
            URLQueryItem(name: QueryParams.longitude.rawValue, value: String(location.longitude)),
        ]

        guard let url = components.url else {
            return Fail(outputType: NearbyMarketsResponse.self, failure: MarketsAPIClientError.badURLComponents).eraseToAnyPublisher()
        }

        let request = URLRequest(url: url)

        return apiClient.run(request)
    }

    func requestMarketDetails(for market: NearbyMarket) -> AnyPublisher<NearbyMarketDetailsResponse, Error> {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(Path.marketDetail.rawValue), resolvingAgainstBaseURL: true) else {
            return Fail(outputType: NearbyMarketDetailsResponse.self, failure: MarketsAPIClientError.badURLComponents).eraseToAnyPublisher()
        }

        components.queryItems = [
            URLQueryItem(name: QueryParams.marketID.rawValue, value: market.id),
        ]

        guard let url = components.url else {
            return Fail(outputType: NearbyMarketDetailsResponse.self, failure: MarketsAPIClientError.badURLComponents).eraseToAnyPublisher()
        }

        let request = URLRequest(url: url)

        return apiClient.run(request)
    }

}

