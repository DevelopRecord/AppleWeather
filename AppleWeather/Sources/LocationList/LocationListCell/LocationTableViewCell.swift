//
//  LocationTableViewCell.swift
//  AppleWeather
//
//  Created by LeeJaeHyeok on 2022/02/23.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    // MARK: Properties

    public static let identifier = "LocationTableViewCell"

    let MyLocationLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 20)
    }

    let currentTimeLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 12)
    }

    let weatherDescriptionLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
    }

    let tempLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 40)
    }

    let minTempLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 12)
    }

    let maxTempLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 12)
    }

    // MARK: Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(MyLocationLabel)
        contentView.addSubview(currentTimeLabel)
        contentView.addSubview(weatherDescriptionLabel)
        contentView.addSubview(tempLabel)
        contentView.addSubview(minTempLabel)
        contentView.addSubview(maxTempLabel)

        MyLocationLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalTo(contentView.safeAreaLayoutGuide.snp.leading).offset(10)
        }

        currentTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(MyLocationLabel.snp.bottom).offset(5)
            make.leading.equalTo(contentView.safeAreaLayoutGuide.snp.leading).offset(10)
        }

        weatherDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide.snp.leading).offset(10)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }

        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide.snp.trailing).offset(-10)
        }

        minTempLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.safeAreaLayoutGuide.snp.trailing).offset(-10)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }

        maxTempLabel.snp.makeConstraints { make in
            make.trailing.equalTo(minTempLabel.snp.leading).offset(-5)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }




}
