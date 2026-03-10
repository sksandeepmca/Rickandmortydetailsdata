//
//  NetworkError.swift
//  RickAndMortyEpisode
//
//  Created by Sandeep on 3/6/26.
//

import Foundation

// MARK: - enum to handle api and persistance Error cases and their description.
public enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(Int)
    case persistenceError(Error)
    case unknown
    public var errorDescription: String? {
        switch self {
        case .invalidURL: return "invalid URL."
        case .invalidResponse: return "invalid response from server."
        case .decodingError:
            return "Failed to Decode response."
        case .serverError(let code):
            return "server error with code \(code)."
        case .persistenceError:
            return "Failed to save or load local data."
        case .unknown: return "unknown error occured."
        }
    }
}
