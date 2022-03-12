//
//  WeatherModel.swift
//  AppleWeather
//
//  Created by LeeJaeHyeok on 2022/02/15.
//

import Foundation

struct WeatherModelResponse: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current?
    let hourly: [Hourly]
    let daily: [Daily]

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, hourly, daily
    }

    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        lat = (try? value.decode(Double.self, forKey: .lat)) ?? 0
        lon = (try? value.decode(Double.self, forKey: .lon)) ?? 0
        timezone = (try? value.decode(String.self, forKey: .timezone)) ?? ""
        timezoneOffset = (try? value.decode(Int.self, forKey: .timezoneOffset)) ?? 0
        current = (try value.decode(Current.self, forKey: .current))
        hourly = (try value.decode([Hourly].self, forKey: .hourly))
        daily = (try value.decode([Daily].self, forKey: .daily))
    }
}

// MARK: Current
// dt(현재시간?), uvi(자외선지수), sunrise(일출), sunset(일몰), temp(온도), feels_like(체감온도), pressure(기압), humidity(습도), visibility(가시거리), wind_speed(바람 초속), dew_point(이슬점) << 바람 이거는 소수점 다 떼고(seil())써야할듯
struct Current: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    let dewPoint: Double
    let uvi: Double
    let visibility: Int
    let windSpeed: Double
    let weather: [Weather]

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, visibility
        case windSpeed = "wind_speed"
        case weather
    }

    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        dt = (try? value.decode(Int.self, forKey: .dt)) ?? 0
        sunrise = (try? value.decode(Int.self, forKey: .sunrise)) ?? 0
        sunset = (try? value.decode(Int.self, forKey: .sunset)) ?? 0
        temp = (try? value.decode(Double.self, forKey: .temp)) ?? 0
        feelsLike = (try? value.decode(Double.self, forKey: .feelsLike)) ?? 0
        pressure = (try? value.decode(Int.self, forKey: .pressure)) ?? 0
        humidity = (try? value.decode(Int.self, forKey: .humidity)) ?? 0
        dewPoint = (try? value.decode(Double.self, forKey: .dewPoint)) ?? 0
        uvi = (try? value.decode(Double.self, forKey: .uvi)) ?? 0
        visibility = (try? value.decode(Int.self, forKey: .visibility)) ?? 0
        windSpeed = (try? value.decode(Double.self, forKey: .windSpeed)) ?? 0
        weather = (try value.decode([Weather].self, forKey: .weather))
    }
}

// MARK: Hourly

struct Hourly: Codable {
    let dt: Int?
    let temp: Double?
    let weather: [Weather]?
}

// MARK: Daily
// 요일, 아이콘, 최저온도, 최고온도
struct Daily: Codable {
    let dt: Int?
    let temp: Temp?
    let weather: [Weather]?
    let rain: Double?
}

struct Temp: Codable {
//    let day: Double?
    let min: Double?
    let max: Double?
}

// MARK: Current, Hourly 내부에 들어가는 Weather 정보

struct Weather: Codable {
    let id: Int
    let main: String?
    let description: String?
    let icon: String?
}
