//
//  NetworkingService.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 24.08.2025.
//

import Foundation

protocol NetworkingServiceful {
    func run<R: Decodable>(endpoint: Endpoint) async throws -> R
}

struct NetworkingService: NetworkingServiceful {
    private let configuration: ApplicationConfiguration
    private let converter: HTTPHeadersConverter

    init(
        configuration: ApplicationConfiguration,
        converter: HTTPHeadersConverter
    ) {
        self.configuration = configuration
        self.converter = converter
    }

    func run<R: Decodable>(endpoint: Endpoint) async throws -> R {
        guard let url = makeURL(endpoint: endpoint, host: configuration.host) else {
            throw NetworkingError.badURL
        }

        let data = try await getDataFromURL(endpoint: endpoint, url: url)
        let decodedData: R = try decode(data: data)

        return decodedData
    }
}

// MARK: - DecodeData
private extension NetworkingService {
    func decode<R: Decodable>(data: Data) throws -> R {
        do {
            let decodedData = try JSONDecoder().decode(R.self, from: data)
            return decodedData
        } catch {
            throw NetworkingError.failToDecodeData
        }
    }
}

// MARK: - GetDataFromURL
private extension NetworkingService {
    func getDataFromURL(endpoint: Endpoint, url: URL) async throws -> Data {
        let request = makeURLRequest(from: endpoint, and: url)
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkingError.unknown
        }

        return try handleGetDataFromURL(code: httpResponse.statusCode, data: data)
    }

    func handleGetDataFromURL(
        code: Int,
        data: Data
    ) throws -> Data {
        switch code {
        case 200...299:
            return data
        default:
            if let errorResponse = try? JSONDecoder().decode(NetworkingErrorResponse.self, from: data) {
                throw NetworkingError.api(error: errorResponse)
            } else {
                throw NetworkingError.unknown
            }
        }
    }
}

// MARK: - URL
private extension NetworkingService {
    func makeURL(
        endpoint: Endpoint,
        host: String
    ) -> URL? {
        var components = URLComponents()

        components.scheme = "https"
        components.host = host
        components.path = endpoint.path
        components.queryItems = endpoint.query.map { name, value in
            URLQueryItem(name: name, value: value)
        }

        return components.url
    }
}

// MARK: - URLRequest
private extension NetworkingService {
    func makeURLRequest(from endpoint: Endpoint, and url: URL) -> URLRequest {
        var request = URLRequest(url: url)

        request.httpBody = endpoint.body
        request.httpMethod = endpoint.method.rawValue.uppercased()
        request.allHTTPHeaderFields = converter.convert(
            apiKey: configuration.apiKey,
            headers: endpoint.headers
        )

        return request
    }
}
