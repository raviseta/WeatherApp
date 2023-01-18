//
//  WeatherDataService.swift
//  WeatherApp
//
//  Created by raviseta on 17/01/23.
//

import Foundation

enum WeatherApi {
    case list
    case invalid
    var apiURL: String {
        switch self {
        case .list:
            return Constants.URLs.baseURL + Constants.URLs.weatherListEndpoints
        case .invalid:
            return Constants.URLs.baseURL
        }
    }
}

protocol WeatherDataServiceProtocol {
    func getForeCastData(api: WeatherApi) async throws -> [Forecastday]
}

class WeatherDataService: WeatherDataServiceProtocol {
    private var networkManager: NetworkManagerProtocol
    
    init(withNetworkManager: NetworkManagerProtocol) {
        self.networkManager = withNetworkManager
    }
    
    
    func getForeCastData(api: WeatherApi) async throws -> [Forecastday] {
        do {
            // Check if api url is correct
            let url = try createURL(api: api)
            let responseData = try await self.networkManager.initiateServiceRequest(url: url)
            let responseDictData = try self.parseServerResponseData(serverResponseData: responseData)
            return responseDictData.forecast.forecastday
        } catch {
            throw error
        }
    }
    
    private func createURL(api: WeatherApi) throws -> URL {
        guard let components = URLComponents(string: api.apiURL) else {
            throw APIError.invalidURL
        }
        
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        return url
    }
    
    private func parseServerResponseData(serverResponseData: Data?) throws -> Weather {
        guard let data = serverResponseData
        else {  throw APIError.responseError }
        do {
            let weatherDict = try JSONDecoder().decode(Weather.self, from: data)
            return weatherDict
        } catch (let error) {
            print(error.localizedDescription)
            throw APIError.responseError
        }
    }
}
