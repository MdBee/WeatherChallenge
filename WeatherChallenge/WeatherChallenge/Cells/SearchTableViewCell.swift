//
//  SearchTableViewCell.swift
//  WeatherChallenge
//
//  Created by Bearson, Matt D. on 11/26/17.
//  Copyright © 2017 Bearson, Matt D. All rights reserved.
//

import UIKit
import UIKit

protocol SearchTableViewCellDelegate {
    func didDelete(weatherGeneral: WeatherGeneral)
}

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var delegate: SearchTableViewCellDelegate?
    var weatherGeneral: WeatherGeneral? { didSet{ self.updateUI() } }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI()
    {
        //collectionView.dataSource = iconDatasource
        
        if let weatherGeneral = weatherGeneral
        {
            self.placeNameLabel.text = weatherGeneral.name ?? ""
            self.degreesLabel.text = String.init(format: "%.1f", weatherGeneral.temp) + "°"
            
            let formatter = DateFormatter()
            formatter.timeZone = NSTimeZone.default
            formatter.dateFormat =  "yyyy-MM-dd HH:mm:ss"
            
            if let date = weatherGeneral.lastUpdate
            {
                self.lastUpdateLabel.text = "Last update: " + formatter.string(from: date as Date)
            }
        }
        
        if let weatherList = weatherGeneral?.weather?.allObjects as? [Weather]
        {
//            iconDatasource.weathers = weatherList
//            self.collectionView.reloadData()
        }
    }
    
    @IBAction func deleteButtonTap(_ sender: Any) {
        if let weatherGeneral = weatherGeneral
        {
            delegate?.didDelete(weatherGeneral: weatherGeneral)
        }
    }
}
