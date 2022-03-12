//
//  DailyTableViewCell.swift
//  AppleWeather
//
//  Created by LeeJaeHyeok on 2022/02/18.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    public static let identifier = "DailyTableViewCell"
    
    let dayOfTheWeekLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.text = "오늘"
    }
    
    let weatherIconImage = UIImageView().then {
        $0.image = UIImage(systemName: "icloud.fill")
    }
    
    let minTempLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.textColor = .lightGray
        $0.text = "-3°"
    }
    
    let maxTempLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.textColor = .lightGray
        $0.text = "8°"
    }
    
    // MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(dayOfTheWeekLabel)
        contentView.addSubview(weatherIconImage)
        contentView.addSubview(minTempLabel)
        contentView.addSubview(maxTempLabel)
        
        dayOfTheWeekLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView.safeAreaLayoutGuide.snp.leading).offset(10)
        }
        
        weatherIconImage.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(dayOfTheWeekLabel.snp.trailing).offset(65)
        }
        
        minTempLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.trailing.equalTo(maxTempLabel.snp.leading).offset(-50)
        }
        
        maxTempLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide.snp.trailing).offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
