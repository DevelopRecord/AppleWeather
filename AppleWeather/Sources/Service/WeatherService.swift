//
//  WeatherService.swift
//  AppleWeather
//
//  Created by LeeJaeHyeok on 2022/02/15.
//

import Foundation
import Alamofire
import CoreLocation

enum NetworkingError: Error {
    case badUrl, noData, decodingError
}

class WeatherService: NSObject, CLLocationManagerDelegate {

    // API Key 값이 악용되는 것을 방지하기 위해 API Key 값을 숨깁니다.
    private var apiKey: String {
        get {
            // 생성한 .plist 파일 경로 찾기
            guard let filePath = Bundle.main.path(forResource: "WeatherAPIKey", ofType: "plist") else {
                fatalError("DEBUG: 'WeatherAPIKey.plist' 파일을 찾을 수 없습니다.")
            }
            // .plist를 딕셔너리로 받기
            let plist = NSDictionary(contentsOfFile: filePath)

            // 딕셔너리에서 값 찾기
            guard let value = plist?.object(forKey: "OPENWEATHERMAP_KEY") as? String else {
                fatalError("DEBUG: 'WeatherAPIKey.plist'에서 'OPENWEATHERMAP_KEY'를 찾을 수 없습니다.")
            }
            return value
        }
    }

    func getAllWeatherInfo3(lat: Double, lon: Double, completion: @escaping(Result<WeatherModelResponse, NetworkingError>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely&appid=\(apiKey)"
        guard let url = URL(string: urlString) else { return completion(.failure(.badUrl)) }

        AF.request(url, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).responseDecodable(of: WeatherModelResponse.self) { response in

            if let error = response.error {
                print("DEBUG: 데이터가 없습니다.. \(error)")
                return completion(.failure(.noData))
            }

            if let weatherResponse = response.value {
                print("DEBUG: weatherResponse의 데이터를 성공적으로 불러왔습니다..")
                return completion(.success(weatherResponse))
            } else {
                print("DEBUG: 디코딩 중 에러가 발생했습니다..")
                return completion(.failure(.decodingError))
            }
        }
    }

    func getAllWeatherInfo(completion: @escaping(Result<WeatherModelResponse, NetworkingError>) -> Void) {
        let locationManager: CLLocationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // 포그라운드 일 때 위치 추적 요청
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 배터리에 맞게 권장되는 최적의 정확도
        locationManager.startUpdatingLocation() // 위치 업데이트

        let coordinate = locationManager.location?.coordinate
        let latitude = coordinate?.latitude
        let longitude = coordinate?.longitude

        if let lat = latitude, let lon = longitude {
            let formattedLat = String(format: "%.2f", lat)
            let formattedLon = String(format: "%.2f", lon)
            let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(formattedLat)&lon=\(formattedLon)&exclude=minutely&appid=\(apiKey)"
            guard let url = URL(string: urlString) else { return completion(.failure(.badUrl)) }

            AF.request(url, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).responseDecodable(of: WeatherModelResponse.self) { response in

                if let error = response.error {
                    print("DEBUG: 데이터가 없습니다.. \(error)")
                    return completion(.failure(.noData))
                }

                if let weatherResponse = response.value {
                    print("DEBUG: weatherResponse의 데이터를 성공적으로 불러왔습니다..")
                    return completion(.success(weatherResponse))
                } else {
                    print("DEBUG: 디코딩 중 에러가 발생했습니다..")
                    return completion(.failure(.decodingError))
                }
            }
        } else {
            print("최초 실행 시 위도와 경도에 대한 정보 값이 없습니다. 위치정보 권한 확인 후 재시도 해주세요.")
        }
    }

    func fetchSearchWeatherData(lat: Double, lon: Double, completion: @escaping(Result<WeatherModelResponse, NetworkingError>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely&appid=\(apiKey)"

        guard let url = URL(string: urlString) else { return }

        AF.request(url, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).responseDecodable(of: WeatherModelResponse.self) { response in

            if let error = response.error {
                print("DEBUG: 검색된 데이터가 없습니다.. \(error)")
                return completion(.failure(.noData))
            }

            if let weatherResponse = response.value {
                print("DEBUG: 검색된 weatherResponse의 데이터를 성공적으로 불러왔습니다..")
                return completion(.success(weatherResponse))
            } else {
                print("DEBUG: 디코딩 중 에러가 발생했습니다..")
                return completion(.failure(.decodingError))
            }
        }
    }
}
