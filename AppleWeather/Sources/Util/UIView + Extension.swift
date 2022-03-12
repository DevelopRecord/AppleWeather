//
//  UIView + Extension.swift
//  AppleWeather
//
//  Created by LeeJaeHyeok on 2022/03/08.
//

import UIKit

extension UIView {
    ///  여러개의 서브뷰를 생성
    func addSubviews(views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}
