//
//  HourlyTableViewCell.swift
//  AppleWeather
//
//  Created by LeeJaeHyeok on 2022/02/21.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    let hourlyLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    let weatherIconImage = UIImageView().then {
        $0.image = UIImage(systemName: "icloud.fill")
    }
    
    let tempLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.textColor = .lightGray
        $0.text = "-3°"
    }
    
    // MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(hourlyLabel)
        contentView.addSubview(weatherIconImage)
        contentView.addSubview(tempLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
