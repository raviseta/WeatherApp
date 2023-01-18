//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by raviseta on 17/01/23.
//

import UIKit
import SDWebImage
import Foundation

protocol WeatherCellAppearanceProtocol {
    func updateCellProperties(cellViewModel: WeatherCellViewModel)
}

class WeatherCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet private var Day: UILabel!
    @IBOutlet private var ivIcon: UIImageView!
    @IBOutlet private var minTempreture: UILabel!
    @IBOutlet private var maxTempreture: UILabel!
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    var cellViewModel: WeatherCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func configureView() {
        // Cell view customization
        backgroundColor = .clear
        
        // Line separator full width
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        
        // Cell label properties
        self.Day.numberOfLines = 0
        self.Day.lineBreakMode = .byWordWrapping
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}

extension WeatherCell: WeatherCellAppearanceProtocol {
    func updateCellProperties(cellViewModel: WeatherCellViewModel) {
        self.Day.text = cellViewModel.day
        self.minTempreture.text = String(cellViewModel.minTemperature)
        self.maxTempreture.text = String(cellViewModel.maxTemperature)
        if let imageURL = URL(string: cellViewModel.imageUrl) {
            self.ivIcon.contentMode = .scaleAspectFill
            self.ivIcon.sd_setImage(with: imageURL,
                                    placeholderImage: UIImage(named: Constants.Image.placeholderImage),
                                    options: .transformAnimatedImage, context: nil)
        }
    }
}
