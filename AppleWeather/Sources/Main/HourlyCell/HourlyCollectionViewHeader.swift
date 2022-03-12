//
//  HourlyCollectionViewHeader.swift
//  AppleWeather
//
//  Created by LeeJaeHyeok on 2022/02/22.
//

import UIKit

class HourlyCollectionViewHeader: UICollectionReusableView {
    
    // MARK: Properties
    
    public static let identifier = "HourlyCollectionViewHeader"
    
    let currentDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "17:00쯤 맑은 상태가 예상됩니다."
        return label
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(currentDescriptionLabel)
        currentDescriptionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(snp.centerY)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
