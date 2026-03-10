//
//  ServiceLayer.swift
//  RickAndMortyEpisode
//
//  Created by Sandeep on 3/6/26.
//

import Foundation

// MARK: - enum to handle API urls
enum APIEndpoint {
    case fecthRecords
    var url: URL? {
    switch self {
    case .fecthRecords: return URL(string: "https://rickandmortyapi.com/api/character")
    }
        }}

// MARK: - protocol blueprint to handle get records from server as well as save server resords in persistance storage.

protocol APIServiceProtocol {
    // Fetch records from server through API
    func getRecords() async throws -> [Results]
    // fetch local data base records
    func getPersistanceRecords() async throws -> [Results]
    // Save server records in local DB
    func saveRecordsInLocalStorage(records: [Results]) async throws
}

// MARK: - This class to fetch episode records from server and also handled response errors.

public class APIServiceProvider {
// Make the initializer public so it can be used as default argument in a public initializer
    public init() {}
    func getRecords() async throws -> [Results] {
        guard let url = APIEndpoint.fecthRecords.url else { throw NetworkError.invalidURL
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            guard(200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(httpResponse.statusCode)
            }
            do {
                let records = try JSONDecoder().decode(Records.self, from: data)
                if let reordsResult = records.results {
                    return reordsResult } else { print("No records found"); throw NetworkError.invalidResponse
                    }
            } catch {
                throw NetworkError.decodingError
            }
        } catch {
            throw NetworkError.unknown
        }
    }
}
