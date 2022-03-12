//
//  SearchResultCell.swift
//  AppleWeather
//
//  Created by LeeJaeHyeok on 2022/02/26.
//

import UIKit
import Then

class SearchResultCell: UITableViewCell {

    // MARK: Properties
    
    public static let identifier = "SearchResultCell"

    let titleLabel = UILabel()

    // MARK: Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView.safeAreaLayoutGuide.snp.leading).offset(10)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
