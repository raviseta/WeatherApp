//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by raviseta on 17/01/23.
//

import Foundation

protocol WeatherViewModelProtocol: AnyObject {
    var reloadTableView: (() -> Void)? { get  set}
    var shouldShowAnimator: ((Bool) -> Void)? { get  set}
    var showAPIError: ((Error) -> Void)? { get  set}
    var forcastArray: [Forecastday] { get }
    func getWeatherData() async
    func getCellViewModel(at indexPath: IndexPath) -> WeatherCellViewModel
}

final class WeatherViewModel: WeatherViewModelProtocol {
    // MARK: Properties
    var shouldShowAnimator: ((Bool) -> Void)?
    var reloadTableView: (() -> Void)?
    var showAPIError: ((Error) -> Void)?
    private var forcastDataService: WeatherDataServiceProtocol
    var forcastArray = [Forecastday]()
    
    // Obeserved Properties
    var isDataLoading = true {
        didSet {
            shouldShowAnimator?(isDataLoading)
        }
    }
    
    var weatherCellViewModels = [WeatherCellViewModel]() {
        didSet {
            reloadTableView?()
        }
    }
    
    var serverError: Error? {
        didSet {
            guard let serverError = serverError else {
                return
            }
            showAPIError?(serverError)
        }
    }
    
    // MARK: Methods
    init(forcastDataService: WeatherDataServiceProtocol) {
        self.forcastDataService = forcastDataService
    }
    
    func getWeatherData() async {
        self.isDataLoading = true
        do {
            let forCastData = try await forcastDataService.getForeCastData(api: .list)
            self.isDataLoading = false
            self.forcastArray = forCastData
            self.createForcastCellModels()
        } catch {
            self.isDataLoading = false
            self.serverError = error
        }
    }
    
    private func createForcastCellModels() {
        var cellModels = [WeatherCellViewModel]()
        for obj in self.forcastArray {
            cellModels.append(createCellModel(forcast: obj))
        }
        self.weatherCellViewModels = cellModels
    }
    
    private func createCellModel(forcast: Forecastday) -> WeatherCellViewModel {
        let day = forcast.date ?? ""
        let maxTempC = forcast.day?.maxtempC ?? 0
        let minTempC = forcast.day?.mintempC ?? 0
        let imgUrl = forcast.day?.condition?.icon ?? ""
        let finalURL = "https:" + imgUrl
        return WeatherCellViewModel(day: day, minTemperature: minTempC, maxTemperature: maxTempC, imageUrl: finalURL)
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> WeatherCellViewModel {
        return weatherCellViewModels[indexPath.row]
    }
}
