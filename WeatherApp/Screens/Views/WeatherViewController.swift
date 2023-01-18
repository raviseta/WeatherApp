//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by raviseta on 17/01/23.
//

import UIKit

class WeatherViewController: BaseViewController {

    // MARK: - Properties
    @IBOutlet weak private var tblForecastList: UITableView!
    @IBOutlet private var animator: UIActivityIndicatorView!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    private lazy var viewModel: WeatherViewModelProtocol = {
        WeatherViewModel(forcastDataService: WeatherDataService(withNetworkManager: NetworkManager()))
    }() as WeatherViewModelProtocol

    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureViewModel()
    }
    
    private func configureView() {
        animator.startAnimating()
        setTableViewProperties()
        setNavigationAppearance(title: Constants.Texts.weatherListTitle)
    }
    
    private func setTableViewProperties() {
        tblForecastList.delegate = self
        tblForecastList.dataSource = self
        tblForecastList.separatorColor = .lightGray
        tblForecastList.separatorStyle = .singleLine
        tblForecastList.tableFooterView = UIView()
        tblForecastList.tableHeaderView = UIView()
        tblForecastList.register(WeatherCell.nib, forCellReuseIdentifier: WeatherCell.identifier)
    }
    
    private func configureViewModel() {
        fetchWeatherData()
        
        // All callbacks from view models
        handleDataLoader()
        handleErrorNotification()
        handleTableviewRefreshActivity()
    }

}

extension WeatherViewController {
    private func fetchWeatherData() {
        // Get data from VM
        Task {[weak self] in
            await self?.viewModel.getWeatherData()
        }
    }
    
    private func handleDataLoader() {
        // Show loader till list appears
        self.animator.hidesWhenStopped = true
        viewModel.shouldShowAnimator = { [weak self] showLoader in
            Task {[weak self] in
                self?.showDataLoader(show: showLoader)
            }
        }
    }
    
    private func handleErrorNotification() {
        // Show network error message
        viewModel.showAPIError = { [weak self] error in
            Task {[weak self] in
                guard let sourceVC = self else {return}
                self?.showApplicationAlert(sourceVC, alertTitle: error.localizedDescription)
            }
        }
    }
    
    private func handleTableviewRefreshActivity() {
        // Reload TableView closure
        viewModel.reloadTableView = { [weak self] in
            Task {[weak self] in
                self?.reloadTableView()
            }
        }
    }

    
    // MARK: UI update operations done using Mainactor on main thread
    @MainActor
    private func reloadTableView() {
        self.tblForecastList.reloadData()
    }
    
    @MainActor
    private func showDataLoader(show: Bool) {
        if show {
            self.animator.startAnimating()
        } else {
            self.animator.stopAnimating()
        }
    }
    
    @MainActor
    private func showApplicationAlert(_ sourceVC: WeatherViewController, alertTitle: String) {
        Alert.present(title: alertTitle, message: "", actions: .okay(handler: {
        }), from: sourceVC)
    }
}


// MARK: - UITableViewDelegate

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.Value.tableRowEstimatedHeight // estimated height
    }
    
}

// MARK: - UITableViewDataSource

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.forcastArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.identifier, for: indexPath) as? WeatherCell
        else { fatalError(Constants.ErrorMessages.xibNotFound) }
        // cell  will be created with CellVM data
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.cellViewModel = cellVM
        cell.updateCellProperties(cellViewModel: cellVM)
        return cell
    }
}
