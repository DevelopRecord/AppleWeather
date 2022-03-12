//
//  String + Extension.swift
//  AppleWeather
//
//  Created by LeeJaeHyeok on 2022/02/19.
//

import UIKit

extension String {

    /// timezone을 통한 현지시간 설정 -> 24시 표기법 반환
    func nowTime(_ format: String, _ timezone: Int) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(Double(self)!))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezone)
        return dateFormatter.string(from: date as Date)
    }

    /// UTC -> 한국 요일 반환
    func weekDayFromDate() -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(Double(self)!))
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date as Date)
    }
    
    func convertCelsius(temp: Double) -> String {
        let celsiusUnit = UnitTemperature.celsius
        let resultDayTemp = celsiusUnit.converter.value(fromBaseUnitValue: temp)
        return String(format: "%.0f", resultDayTemp)
    }
}
