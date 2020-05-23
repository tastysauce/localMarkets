import Foundation
import Combine
import UIKit
import CoreLocation

// MARK: JSON

let marketsPrefilledData = """
{
    "results": [
        {"id":"1011488","marketname":"1.8 Belmont Certified Farmers' Market"},
        {"id":"1011494","marketname":"2.4 San Mateo @ 25th Ave. Certified Farmers' Market"},
        {"id":"1007861","marketname":"2.5 San Carlos CFM"},
        {"id":"1011495","marketname":"2.5 College of San Mateo Certified Farmers' Market"},
        {"id":"1007859","marketname":"2.5 San Mateo Event Center CFM"},
        {"id":"1005620","marketname":"4.0 PJCC Farmers' Market at Foster City"},
        {"id":"1007863","marketname":"4.1 Urban Table Certified Farmer's Market"},
        {"id":"1000791","marketname":"4.2 Redwood City Kiwanis Farmers Market"},
        {"id":"1011485","marketname":"4.6 Kaiser Redwood City Certified Farmers' Market"},
        {"id":"1005322","marketname":"5.2 Burlingame Fresh Market Farmers Market"},
        {"id":"1007860","marketname":"6.2 The Fresh Market Burlingame (2)"},
        {"id":"1002905","marketname":"7.7 Menlo Park Farmers' Market"},
        {"id":"1018163","marketname":"7.7 Coastside Farmers' Market - Half Moon Bay "},
        {"id":"1003182","marketname":"7.9 Millbrae Farmers Market"},
        {"id":"1019721","marketname":"9.1 Downtown Palo Alto Farmers' Market"},
        {"id":"1000291","marketname":"9.3 Stanford CFM"},
        {"id":"1005342","marketname":"9.7 East Palo Alto Community Farmers Market"},
        {"id":"1006596","marketname":"10.8 San Bruno Farmers' Market"},
        {"id":"1011498","marketname":"11.5 VA Palo Alto Farmers' Market"}
    ]
}
""".data(using: .utf8)!

let detailsPrefilledData = """
{
    "marketdetails": {
        "Address": "El Camino Real and O'Neill St., Belmont, California, 94002",
        "GoogleLink": "http://maps.google.com/?q=37.518818%2C%20-122.2736%20(%22Belmont+Certified+Farmers'+Market%22)",
        "Products": "Baked goods; Cut flowers; Eggs; Fish and/or seafood; Fresh fruit and vegetables; Fresh and/or dried herbs; Honey; Meat; Plants in containers",
        "Schedule": "01/01/2015 to 12/31/2015 Sun: 9:00 AM-1:00 PM;<br> <br> <br> "
    }
}
""".data(using: .utf8)!

//MARK: Location

struct Location {
    var latitude: Double
    var longitude: Double

    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

    init(coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    static var invalidLocation: Location {
        Location(coordinate: kCLLocationCoordinate2DInvalid)
    }
}

//MARK: Market

struct NearbyMarketsResponse: Codable {

    var markets: [NearbyMarket]

    enum CodingKeys: String, CodingKey {
        case markets = "results"
    }

}

struct NearbyMarket: Codable, Identifiable {

    var id: String
    var marketName: String
    var distance: Double

    enum CodingKeys: String, CodingKey {
        case id
        case marketName = "marketname"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)

        let distanceAndName = try values.decode(String.self, forKey: .marketName)
        let components = distanceAndName.components(separatedBy: " ")

        guard components.count > 1, let componentDistance = Double(components[0]) else {
            throw ParsingError.invalidJSON
        }

        marketName = components.suffix(from: 1).joined(separator: " ")
        distance = componentDistance
    }

}

//MARK: Market Details

struct NearbyMarketDetailsResponse: Codable {

    var marketDetails: NearbyMarketDetails

    enum CodingKeys: String, CodingKey {
        case marketDetails = "marketdetails"
    }

}

struct NearbyMarketDetails: Codable {

    var address: String
    var googleMapsLink: URL
    var products: String // TODO: Make an enum for the products!
    var schedule: String // TODO: This will need parsing
    // Calculated var lat/lon

    enum CodingKeys: String, CodingKey {
        case address = "Address"
        case googleMapsLink = "GoogleLink"
        case products = "Products"
        case schedule = "Schedule"
    }

}

struct Market {

    // from NearbyMarket
    var id: String
    var marketName: String
    var distance: Double

    // from NearbyMarketDetails
    var address: String
    var googleMapsLink: URL
    var products: String // TODO: Make an enum for the products!
    var schedule: String // TODO: This will need parsing

    var location: Location = .invalidLocation

    init(
        nearbyMarket: NearbyMarket,
        nearbyMarketDetails: NearbyMarketDetails) {
        self.id = nearbyMarket.id
        self.marketName = nearbyMarket.marketName
        self.distance = nearbyMarket.distance
        self.address = nearbyMarketDetails.address
        self.googleMapsLink = nearbyMarketDetails.googleMapsLink
        self.products = nearbyMarketDetails.products
        self.schedule = nearbyMarketDetails.schedule
    }

}

// MARK: API Client

struct APIClient {

    enum APIClientError: Error {
        case badResponse(_ response: URLResponse)
        case statusCode(_ code: Int)
    }

    func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        URLSession.shared
            .dataTaskPublisher(for: request)
            .retry(1)
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

// MARK: MarketsAPIClient

enum ParsingError: Error {
    case invalidJSON
}

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
            .eraseToAnyPublisher()
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
            .eraseToAnyPublisher()
    }

}

class TestClient {
    @Published var markets: [Market] = []

    @Published var nearbyMarkets: [NearbyMarket] = [] // temp

    var cancellationToken: AnyCancellable?
    var disposeBag = Set<AnyCancellable>()
    let marketsAPIClient = MarketsAPIClient(apiClient: APIClient())

    func getMarkets(with prefilledData: Data?) {

        $markets
            .sink {
                print("finalArray: " + "\($0.map { $0.googleMapsLink.absoluteString + $0.id })")
            }
            .store(in: &disposeBag)

        if let prefilledData = prefilledData {
            let marketsResponse = try! JSONDecoder().decode(NearbyMarketsResponse.self, from: prefilledData)
            nearbyMarkets = marketsResponse.markets

            Just(marketsResponse).eraseToAnyPublisher()
                .map(\.markets)
                .setFailureType(to: Error.self)
                .flatMap { (value: [NearbyMarket]) -> AnyPublisher<[Market], Error> in
                    return self.getAllMarketDetails(nearbyMarkets: value)
            }
            .sink(receiveCompletion: { _ in
                print("completion")
            }) { marketsResponse in
                self.markets = marketsResponse
            }
            .store(in: &disposeBag)



        } else {
            marketsAPIClient.requestMarkets(nearby: Location(latitude: 37.509280, longitude: -122.303370))
                .map(\.markets)
                .sink(receiveCompletion: { completion in

                }) { marketsValue in
                    self.nearbyMarkets = marketsValue
            }
            .store(in: &disposeBag)
        }

    }

    func getAllMarketDetails(nearbyMarkets: [NearbyMarket]) -> AnyPublisher<[Market], Error> {
        let arrayOfPublishers = nearbyMarkets.map { getMarketDetails(nearbyMarket: $0) }
        let sequenceOfPublishers = Publishers.Sequence<[AnyPublisher<Market, Error>], Error>(sequence: arrayOfPublishers)
        let marketsPublisher = sequenceOfPublishers.flatMap { $0 }.collect().eraseToAnyPublisher()
        return marketsPublisher
    }

    func getMarketDetails(nearbyMarket: NearbyMarket) -> AnyPublisher<Market, Error> {

        marketsAPIClient.requestMarketDetails(for: nearbyMarket)
            .map(\.marketDetails)
            .map { print("\($0)")
                return $0
        }
            .map { Market(nearbyMarket: nearbyMarket, nearbyMarketDetails: $0) }
            .eraseToAnyPublisher()
    }

}

//let testClient = TestClient()
//testClient.getMarkets(with: marketsPrefilledData)


let marketDetails = try! JSONDecoder().decode(NearbyMarketDetailsResponse.self, from: detailsPrefilledData).marketDetails


