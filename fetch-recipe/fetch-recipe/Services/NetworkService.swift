//
//  NetworkService.swift
//  fetch-recipe
//
//  Created by Caleb Meurer on 12/6/24.
//

import Foundation

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

protocol Networkable {
    func fetchData<T: Decodable>(from endpoint: Endpoint, for type: T.Type) async -> Result<T, NetworkError>
}

class NetworkService: Networkable {
    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func fetchData<T: Decodable>(from endpoint: Endpoint, for type: T.Type) async -> Result<T, NetworkError> {
        guard let url = URL(string: endpoint.rawValue) else {
            return .failure(NetworkError.invalidURL)
        }

        var data: Data
        var response: URLResponse
        do {
            (data, response) = try await session.data(from: url)
        } catch {
            return .failure(.request(error.localizedDescription))
        }

        let decodedData = await validateAndDecode(with: .json, data, response, for: type)
        switch decodedData {
        case .success(let response):
            return .success(response)
        case .failure(let error):
            return .failure(error)
        }
    }

    private func validateAndDecode<T: Decodable>(with decoder: DecoderType, _ data: Data, _ response: URLResponse, for model: T.Type) async -> (Result<T, NetworkError>) {
        if let httpResponse = response as? HTTPURLResponse {
            let isSuccessfulStatusCode = (200...299).contains(httpResponse.statusCode)
            if !isSuccessfulStatusCode {
                return .failure(NetworkError.server("HTTP Error \(httpResponse.statusCode)"))
            }
        }

        do {
            return .success(try decoder.value.decode(model, from: data))
        } catch {
            return .failure(.malformed(error.localizedDescription))
        }
    }
}
