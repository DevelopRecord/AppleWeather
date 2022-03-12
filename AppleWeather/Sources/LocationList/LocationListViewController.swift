//
//  LocationListViewController.swift
//  AppleWeather
//
//  Created by LeeJaeHyeok on 2022/02/23.
//

import UIKit
import CoreLocation
import MapKit

class LocationListViewController: UIViewController {

    // MARK: Properties
    
    private var cityList = [ListModel(title: "나의 위치", subTitle: "", description: "", temp: 0, max: 0, min: 0)]

    var lat: Double?
    var lon: Double?
    var timezone: String?
    var current: Current?
    var daily: Daily?
    private var dailyWeather = [Daily]()

    var searchLocality: String?
    var myAdministrativeArea: String? // 시
    var myLocality: String? // 구(군)

    private var searchCompleter: MKLocalSearchCompleter?
    private var searchRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)
    private var completerResults: [MKLocalSearchCompletion]?

    private var places: MKMapItem? {
        didSet {
            locationTableView.reloadData()
        }
    }

    private var localSearch: MKLocalSearch? {
        willSet {
            places = nil // 새 검색을 시작하기 전에 결과를 지우고 현재 실행 중인 로컬 검색을 취소합니다.
            localSearch?.cancel()
        }
    }

    var filteredCityList: [String] = []

    lazy var locationTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.backgroundColor = .systemGroupedBackground
        tv.separatorStyle = .none
        tv.delegate = self
        tv.dataSource = self
        tv.rowHeight = 120
        return tv
    }()

    lazy var searchTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .systemGroupedBackground
        tv.separatorStyle = .none
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()

    lazy var locationManager = CLLocationManager().then {
        $0.desiredAccuracy = kCLLocationAccuracyBest
        $0.requestWhenInUseAuthorization()
        $0.startMonitoringSignificantLocationChanges()
        $0.delegate = self
    }

    let searchController = UISearchController().then {
        $0.searchBar.placeholder = "도시 또는 공항 검색"
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearchController()
        getAllWeatherInfo()
    }

    // MARK: Helpers

    func configureUI() {
        view.backgroundColor = .systemGroupedBackground
        locationManager.startUpdatingLocation() // 사용자의 위치 정보를 업데이트합니다.

        let rightButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(handleRightButton))
        rightButton.tintColor = .black

        navigationItem.title = "날씨"
        navigationItem.rightBarButtonItem = rightButton

        view.addSubview(locationTableView)
        locationTableView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }

        locationTableView.register(LocationTableViewCell.self, forCellReuseIdentifier: LocationTableViewCell.identifier)
    }

    func configureSearchController() {
        self.navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController

        searchController.searchBar.becomeFirstResponder() // UIKit에게 이 개체를 창의 첫 번째 응답자로 만들도록 요청합니다.
        searchController.searchResultsUpdater = self

        searchCompleter = MKLocalSearchCompleter()
        searchCompleter?.delegate = self
        searchCompleter?.resultTypes = .address
        searchCompleter?.region = searchRegion

        locationTableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.identifier)
    }

    private func search(for suggestedCompletion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: suggestedCompletion)
        search(using: searchRequest)
    }

    // TODO: 검색 대상의 결과 뿌려주기
    private func search(using searchRequest: MKLocalSearch.Request) {
        searchRequest.region = searchRegion // 검색 지역 설정
        searchRequest.resultTypes = .pointOfInterest // 검색 유형 설정
        localSearch = MKLocalSearch(request: searchRequest) // MKLocalSearch 생성

        // 비동기로 검색 실행
        localSearch?.start { [unowned self] (response, error) in
            guard error == nil else { return }
            
            self.places = response?.mapItems[0] // 검색한 결과 : reponse의 mapItems 값을 가져온다.
            let searchResultLat = places?.placemark.coordinate.latitude
            let searchResultLon = places?.placemark.coordinate.longitude
            print("검색한 결과의 위도 값은: \(searchResultLat ?? 0.0), 경도 값은: \(searchResultLon ?? 0.0)")
            let controller = MainViewController()
            controller.isAddCityView = true
            controller.searchedLocality = searchLocality
            controller.searchLat = searchResultLat
            controller.searchLon = searchResultLon

            let navController = UINavigationController(rootViewController: controller)
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .clear
            appearance.shadowColor = .clear
            navController.navigationBar.standardAppearance = appearance
            navController.navigationBar.scrollEdgeAppearance = appearance

            let left = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(handleLeftButton))
            let right = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(handleRightButton))

            navController.navigationBar.topItem?.leftBarButtonItem = left
            navController.navigationBar.topItem?.rightBarButtonItem = right

            self.present(navController, animated: true, completion: nil)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchCompleter = nil // Completer 개체는 수명이 긴 개체이므로 강한 참조를 하기 때문에 viewDidDisappear에서 참조를 해제 해줍니다.
    }

    // MARK: Actions

    @objc func handleRightButton() {
        print("touch!")
        let controller = MainViewController()
        cityList.removeFirst()
        cityList.append(ListModel(title: searchLocality ?? "서울특별시",
                                  subTitle: "18:00",
                                  description: controller.current?.weather[0].main ?? "",
                                  temp: controller.current?.temp,
                                  max: controller.dailyWeather.first?.temp?.max!,
                                  min: controller.dailyWeather.first?.temp?.min))
        
        NotificationCenter.default.post(name: NSNotification.Name("appendListCell"), object: cityList, userInfo: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addCity(_:)), name: NSNotification.Name("appendListCell"), object: nil)
        self.dismiss(animated: true, completion: nil)
        print("------------")
        print("시티 리스트: \(cityList)")
        print("카운트: \(cityList.count)")
        print("------------")
    }
    
    @objc func addCity(_ notification: Notification) {
        if let list = notification.object as? [ListModel] {
            cityList.append(contentsOf: list)
        }
        searchTableView.reloadData()
    }
    
    @objc func handleLeftButton() {
        print("Canceled")
        self.dismiss(animated: true, completion: nil)
    }
}

extension LocationListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completerResults?.isEmpty == true || completerResults?.count == nil ? cityList.count : completerResults?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier, for: indexPath) as! LocationTableViewCell
        cell.backgroundColor = .systemGroupedBackground

        if completerResults?.isEmpty == false {
            let SearchResultCell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.identifier, for: indexPath) as! SearchResultCell
            if let suggestion = completerResults?[indexPath.row] {
                locationTableView.rowHeight = 40
                SearchResultCell.titleLabel.text = suggestion.title
            }
            return SearchResultCell
        } else {
            let daily = dailyWeather.first

            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier, for: indexPath) as! LocationTableViewCell
                cell.backgroundColor = .systemGroupedBackground
                locationTableView.rowHeight = 120

                cell.MyLocationLabel.text = "나의 위치"
                cell.currentTimeLabel.text = self.myLocality

                if let currentTemp = current?.temp, let maxTemp = daily?.temp?.max, let minTemp = daily?.temp?.min {
                    cell.tempLabel.text = "\(String(currentTemp).convertCelsius(temp: currentTemp))°"
                    cell.maxTempLabel.text = "최고:\(String(maxTemp).convertCelsius(temp: maxTemp))°"
                    cell.minTempLabel.text = "최저:\(String(minTemp).convertCelsius(temp: minTemp))°"
                }

                let description = current?.weather[0].description
                if description == "broken clouds" {
                    cell.weatherDescriptionLabel.text = "구름이 많은 상태가 예상됩니다."
                } else if description == "overcast clouds" {
                    cell.weatherDescriptionLabel.text = "흐린 상태가 예상됩니다."
                } else if description == "scattered clouds" {
                    cell.weatherDescriptionLabel.text = "일부 맑은 상태가 예상됩니다."
                } else if description == "few clouds" {
                    cell.weatherDescriptionLabel.text = "대부분 맑은 상태가 예상됩니다."
                } else if description == "clear sky" {
                    cell.weatherDescriptionLabel.text = "맑은 상태가 예상됩니다."
                } else {
                    cell.weatherDescriptionLabel.text = description
                }
                return cell
            default:
                cell.MyLocationLabel.text = cityList[indexPath.row].title
                cell.currentTimeLabel.text = cityList[indexPath.row].subTitle
                cell.weatherDescriptionLabel.text = cityList[indexPath.row].description
                cell.tempLabel.text = "\(cityList[indexPath.row].temp ?? 0.0)"
                cell.maxTempLabel.text = "최고:\(cityList[indexPath.row].max ?? 0.0)"
                cell.minTempLabel.text = "최저:\(cityList[indexPath.row].min ?? 0.0)"
                
                return cell
            }
        }
    }

    //TODO: 선택시 액션
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let suggestion = completerResults?[indexPath.row] {
            print("제안: \(suggestion), 제안 타이틀: \(suggestion.title), 서브타이틀: ")
            self.searchLocality = suggestion.title
            search(for: suggestion)
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("삭제 - \(indexPath.row)")
        } else if editingStyle == .insert {
            print("추가 - \(indexPath.row)")
        }
    }
}

extension LocationListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lat = lat, let lon = lon {
            let findLocation: CLLocation = CLLocation(latitude: lat, longitude: lon)
            let geoCoder = CLGeocoder()
            let locale = Locale(identifier: "Ko-kr") // ko-kr로 하면 '서울' 출력, 하지 않으면 'Seoul' 출력됨
            geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: locale) { placemark, error in
                if let address: [CLPlacemark] = placemark {
                    let area = address.last?.administrativeArea
                    let locality = address.last?.locality

                    if let area = area.map({ $0 }), let local = locality.map({ $0 }) {
                        let resultOfArea = area.reduce("") { return "\($0)" + "\($1)" }
                        let resultOfLocality = local.reduce("") { return "\($0)" + "\($1)" }

                        self.myAdministrativeArea = resultOfArea
                        self.myLocality = resultOfLocality

                        self.locationTableView.reloadData()
                    }
                }
            }
        }
    }
}

extension LocationListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }

        if searchText == "" {
            completerResults = nil
        }

        searchCompleter?.queryFragment = searchText // 사용자가 search bar에 입력한 text를 자동완성 대상에 넣는다.
        locationTableView.reloadData()
    }
}

extension LocationListViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completerResults = completer.results
        locationTableView.reloadData()
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        if let error = error as NSError? {
            print("MKLocalSearchCompleter가 에러 발생: \(error.localizedDescription).\n쿼리프래그먼트 값은: \"\(completer.queryFragment)\"")
        }
    }
}

extension LocationListViewController: UISearchControllerDelegate {

}

private extension LocationListViewController {
    func getAllWeatherInfo() {
        WeatherService().getAllWeatherInfo { result in
            switch result {
            case .success(let weatherResponse):
                DispatchQueue.main.async {
                    self.lat = weatherResponse.lat
                    self.lon = weatherResponse.lon
                    self.timezone = weatherResponse.timezone
                    self.current = weatherResponse.current
                    self.daily = weatherResponse.daily.first
                    self.dailyWeather = weatherResponse.daily
                    self.locationTableView.reloadData()
                }
            case .failure(_):
                print("DEBUG: LocationListViewController 내에서 날씨 정보를 불러오는데 실패했습니다.")
            }
        }
    }
}
