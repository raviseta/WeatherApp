//
//  AppConstants.swift
//  WeatherApp
//
//  Created by raviseta on 17/01/23.
//

import Foundation

struct Constants {
    
    struct Keys {
        static let apiKeys = "522db6a157a748e2996212343221502"
    }
    
    struct Texts {
        static let weatherListTitle = "Weather"
        static let alertOkTitle = "Ok"
        static let alertCancelTitle = "Cancel"
        static let alertQuitTitle = "Quit"
    }
    
    struct URLs {
        static let baseURL = "https://api.weatherapi.com/v1/"
        static let weatherListEndpoints = "forecast.json?key=\(Keys.apiKeys)&q=rajkot&days=7&aqi=no&alerts=no"
    }
    
    struct StoryboardXIBNames {
        static let main = "Main"
    }
    
    struct Value {
        static let tableRowEstimatedHeight = 90.0
    }
  
    struct ErrorMessages {
        static let xibNotFound = "xib does not exists"
        static let invalidURL = "Invalid URL"
        static let invalidResponse = "Invalid response"
        static let unknownError = "Unknown error"
        static let noInternetConnection = "No internet connection"
        static let noError = "No Error"
        static let jailbrokenDevice = "This Device is JailBroken.Please quit the application."
    }
    
    struct Image {
        static let placeholderImage = "placeholderImage.png"
    }
}
