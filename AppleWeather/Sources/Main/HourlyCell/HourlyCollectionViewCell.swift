//
//  HourlyCollectionViewCell.swift
//  AppleWeather
//
//  Created by LeeJaeHyeok on 2022/02/21.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {

    // MARK: Properties
    
    public static let identifier = "HourlyCollectionViewCell"

    let uiView = UIView()
    
    let hourlyLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.text = "지금"
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

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(uiView)
        
        uiView.addSubview(hourlyLabel)
        uiView.addSubview(weatherIconImage)
        uiView.addSubview(tempLabel)
        
        uiView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
        hourlyLabel.snp.makeConstraints { make in
            make.top.equalTo(uiView.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalTo(uiView.snp.centerX)
        }
        
        weatherIconImage.snp.makeConstraints { make in
            make.width.height.equalTo(25)
            make.top.equalTo(hourlyLabel.snp.bottom).offset(10)
            make.centerX.equalTo(uiView.snp.centerX)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherIconImage.snp.bottom).offset(10)
            make.centerX.equalTo(uiView.snp.centerX)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
