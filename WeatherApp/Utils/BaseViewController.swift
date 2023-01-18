//
//  BaseViewController.swift
//  WeatherApp
//
//  Created by raviseta on 17/01/23.
//

import UIKit

class BaseViewController: UIViewController {
    // Put all stuffs which are common to all viewControllers
    func setNavigationAppearance(title: String) {
        self.navigationItem.title = title
    }
}
