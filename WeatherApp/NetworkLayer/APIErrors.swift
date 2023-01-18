//
//  APIErrors.swift
//  WeatherApp
//
//  Created by raviseta on 17/01/23.
//

import Foundation

enum APIError: Error {
    case noNetwork
    case invalidURL
    case responseError
    case unknown
    case noError
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return Constants.ErrorMessages.invalidURL
        case .responseError:
            return Constants.ErrorMessages.invalidResponse
        case .unknown:
            return Constants.ErrorMessages.unknownError
        case .noNetwork:
            return Constants.ErrorMessages.noInternetConnection
        case .noError:
            return Constants.ErrorMessages.noError
        }
    }
}
