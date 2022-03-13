//
//  MainViewController.swift
//  AppleWeather
//
//  Created by LeeJaeHyeok on 2022/02/15.
//

import UIKit
import CoreLocation
import SnapKit
import Kingfisher
import Lottie
import Then

class MainViewController: UIViewController {

    // MARK: Properties

    private var cityList = [ListModel(title: "나의 위치", subTitle: "", description: "", temp: 0, max: 0, min: 0)]
// commit testtt2
    /// 서버에서 불러올 정보
    var lat: Double?
    var lon: Double?
    var timezone: String?
    var timezone_offset: Int?
    var current: Current?
    var hourly: Hourly?
    var daily: Daily?
    var dailyWeather = [Daily]()
    var hourlyWeather = [Hourly]()

    /// 검색 대상의 정보
    var myLocality: String? // 구(군)
    var isAddCityView: Bool = false
    var searchedLocality: String?

    /// 검색 대상의 위, 경도
    var searchLat: Double?
    var searchLon: Double?

    /// 배경 Lottie
    let backgroundView = UIView()
    let animationView = AnimationView()

    /// locationManager 인스턴스 생성
    lazy var locationManager = CLLocationManager().then {
        $0.desiredAccuracy = kCLLocationAccuracyBest
        $0.requestWhenInUseAuthorization()
        $0.startMonitoringSignificantLocationChanges()
        $0.delegate = self
    }

    let scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = true
    }

    let contentView = UIView().then {
        $0.backgroundColor = .clear
    }

    lazy var pageControl = UIPageControl().then {
        $0.backgroundColor = .systemGreen.withAlphaComponent(0.6)
        $0.addTarget(self, action: #selector(handlePageControl), for: .touchUpInside)
    }

    let locationListButton = UIButton().then {
        $0.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        $0.tintColor = .white
        $0.addTarget(self, action: #selector(handleListButton), for: .touchUpInside)
    }

    let currentLocationLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 35)
    }

    let currentTempLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 70)
    }

    let currentMainLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 20)
    }

    let tempView = UIView().then {
        $0.backgroundColor = .clear
    }

    let maxTempLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 18)
    }

    let minTempLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 18)
    }

    let descriptionUIView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .white
    }

    let currentDescriptionLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 14)
    }

    lazy var hourlyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.layer.cornerRadius = 10
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()

    lazy var dailyTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .clear
        tv.isScrollEnabled = false
        return tv
    }()

    let uviView = UIView().then {
        $0.backgroundColor = .white.withAlphaComponent(0.6)
        $0.layer.cornerRadius = 10
    }

    let uviPointLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.textColor = .lightGray
        $0.text = "자외선 지수"
    }

    let uviPoint = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 32)
    }

    let uviDescriptionLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.numberOfLines = 2
    }

    let sunriseView = UIView().then {
        $0.backgroundColor = .white.withAlphaComponent(0.6)
        $0.layer.cornerRadius = 10
    }

    let sunriseLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.textColor = .lightGray
        $0.text = "일출"
    }

    let sunriseTimeLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 32)
    }

    let sunsetTimeLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 14)
    }

    let windSpeedView = UIView().then {
        $0.backgroundColor = .white.withAlphaComponent(0.6)
        $0.layer.cornerRadius = 10
    }

    let windSpeedLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.textColor = .lightGray
        $0.text = "바람"
    }

    let windSpeedPoint = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 32)
        $0.text = "1m/s"
    }

    let precipitationView = UIView().then {
        $0.backgroundColor = .white.withAlphaComponent(0.6)
        $0.layer.cornerRadius = 10
    }

    let precipitationLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.textColor = .lightGray
        $0.text = "강우"
    }

    let precipitationPoint = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 32)
        $0.text = "0mm"
    }

    let precipitationDescriptionLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.text = "이후 일요일에 3mm의 비(이)가 예상됩니다."
        $0.numberOfLines = 2
    }

    let feelsLikeView = UIView().then {
        $0.backgroundColor = .white.withAlphaComponent(0.6)
        $0.layer.cornerRadius = 10
    }

    let feelsLikeLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.textColor = .lightGray
        $0.text = "체감 온도"
    }

    let feelsLikePoint = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 32)
    }

    let feelsLikeDescriptionLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.numberOfLines = 2
    }

    let humidityView = UIView().then {
        $0.backgroundColor = .white.withAlphaComponent(0.6)
        $0.layer.cornerRadius = 10
    }

    let humidityLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.textColor = .lightGray
        $0.text = "습도"
    }

    let humidityPoint = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 32)
    }

    let dewPointDescriptionLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 14)
    }

    let visibilityView = UIView().then {
        $0.backgroundColor = .white.withAlphaComponent(0.6)
        $0.layer.cornerRadius = 10
    }

    let visibilityLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.textColor = .lightGray
        $0.text = "가시거리"
    }

    let visibilityPoint = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 32)
    }

    let visibilityDescriptionLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.numberOfLines = 2
    }

    let pressureView = UIView().then {
        $0.backgroundColor = .white.withAlphaComponent(0.6)
        $0.layer.cornerRadius = 10
    }

    let pressureLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.textColor = .lightGray
        $0.text = "기압"
    }

    let pressurePoint = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 32)
        $0.numberOfLines = 2
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupLocationManager()
        setupPageControl()
    }

    // MARK: Helpers

    func configureUI() {
        view.backgroundColor = .systemGroupedBackground
        scrollView.delegate = self

        let stackTop = UIStackView(arrangedSubviews: [currentLocationLabel, currentTempLabel, currentMainLabel])
        stackTop.axis = .vertical
        stackTop.alignment = .center
        stackTop.spacing = -5

        view.addSubviews(views: [backgroundView, scrollView, pageControl])
        backgroundView.addSubview(animationView)
        scrollView.addSubview(contentView)
        descriptionUIView.addSubview(currentDescriptionLabel)
        pageControl.addSubview(locationListButton)
        tempView.addSubviews(views: [maxTempLabel, minTempLabel])
        contentView.addSubviews(views: [tempView, descriptionUIView, hourlyCollectionView, dailyTableView])
        contentView.addSubviews(views: [uviView, sunriseView, windSpeedView, precipitationView, feelsLikeView, humidityView,
            visibilityView, pressureView, stackTop])
        uviView.addSubviews(views: [uviPointLabel, uviPoint, uviDescriptionLabel])
        sunriseView.addSubviews(views: [sunriseLabel, sunriseTimeLabel, sunsetTimeLabel])
        windSpeedView.addSubviews(views: [windSpeedLabel, windSpeedPoint])
        precipitationView.addSubviews(views: [precipitationLabel, precipitationPoint, precipitationDescriptionLabel])
        feelsLikeView.addSubviews(views: [feelsLikeLabel, feelsLikePoint, feelsLikeDescriptionLabel])
        humidityView.addSubviews(views: [humidityLabel, humidityPoint, dewPointDescriptionLabel])
        visibilityView.addSubviews(views: [visibilityLabel, visibilityPoint, visibilityDescriptionLabel])
        pressureView.addSubviews(views: [pressureLabel, pressurePoint])

        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        animationView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(85)
            make.centerX.equalToSuperview()
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }

        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.width.equalTo(scrollView.snp.width)
        }

        stackTop.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(30)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
        }

        tempView.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(30)
            make.top.equalTo(stackTop.snp.bottom)
            make.centerX.equalTo(contentView.snp.centerX)

            maxTempLabel.snp.makeConstraints { make in
                make.top.equalTo(tempView.snp.top)
                make.centerY.equalTo(tempView.snp.centerY)
                make.leading.equalTo(tempView.snp.leading).offset(5)
            }
            minTempLabel.snp.makeConstraints { make in
                make.top.equalTo(tempView.snp.top)
                make.centerY.equalTo(tempView.snp.centerY)
                make.leading.equalTo(maxTempLabel.snp.trailing).offset(5)
            }
        }

        descriptionUIView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.top.equalTo(tempView.snp.bottom).offset(30)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
            currentDescriptionLabel.snp.makeConstraints { make in
                make.top.equalTo(descriptionUIView.snp.top).offset(10)
                make.leading.equalTo(descriptionUIView.snp.leading).offset(10)
            }
        }

        hourlyCollectionView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.top.equalTo(descriptionUIView.snp.top).offset(30)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
        }

        dailyTableView.snp.makeConstraints { make in
            make.height.equalTo(410)
            make.top.equalTo(hourlyCollectionView.snp.bottom).offset(-20)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }

        uviView.snp.makeConstraints { make in
            make.width.equalTo(180)
            make.height.equalTo(150)
            make.top.equalTo(dailyTableView.snp.bottom)
            make.leading.equalTo(contentView.snp.leading).offset(20)

            uviPointLabel.snp.makeConstraints { make in
                make.top.equalTo(uviView.snp.top).offset(10)
                make.leading.equalTo(uviView.snp.leading).offset(10)
            }

            uviPoint.snp.makeConstraints { make in
                make.top.equalTo(uviPointLabel.snp.bottom).offset(10)
                make.leading.equalTo(uviView.snp.leading).offset(10)
            }

            uviDescriptionLabel.snp.makeConstraints { make in
                make.leading.equalTo(uviView.snp.leading).offset(10)
                make.trailing.equalTo(uviView.snp.trailing).offset(-10)
                make.bottom.equalTo(uviView.snp.bottom).offset(-10)
            }
        }

        sunriseView.snp.makeConstraints { make in
            make.width.equalTo(180)
            make.height.equalTo(150)
            make.top.equalTo(dailyTableView.snp.bottom)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)

            sunriseLabel.snp.makeConstraints { make in
                make.top.equalTo(sunriseView.snp.top).offset(10)
                make.leading.equalTo(sunriseView.snp.leading).offset(10)
            }
            sunriseTimeLabel.snp.makeConstraints { make in
                make.top.equalTo(sunriseLabel.snp.bottom).offset(10)
                make.leading.equalTo(sunriseView.snp.leading).offset(10)
            }
            sunsetTimeLabel.snp.makeConstraints { make in
                make.leading.equalTo(sunriseView.snp.leading).offset(10)
                make.trailing.equalTo(sunriseView.snp.trailing).offset(-10)
                make.bottom.equalTo(sunriseView.snp.bottom).offset(-10)
            }
        }

        windSpeedView.snp.makeConstraints { make in
            make.width.equalTo(180)
            make.height.equalTo(150)
            make.top.equalTo(uviView.snp.bottom).offset(10)
            make.leading.equalTo(contentView.snp.leading).offset(20)

            windSpeedLabel.snp.makeConstraints { make in
                make.top.equalTo(windSpeedView.snp.top).offset(10)
                make.leading.equalTo(windSpeedView.snp.leading).offset(10)
            }
            windSpeedPoint.snp.makeConstraints { make in
                make.top.equalTo(windSpeedLabel.snp.bottom).offset(10)
                make.leading.equalTo(windSpeedView.snp.leading).offset(10)
            }
        }

        precipitationView.snp.makeConstraints { make in
            make.width.equalTo(180)
            make.height.equalTo(150)
            make.top.equalTo(uviView.snp.bottom).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)

            precipitationLabel.snp.makeConstraints { make in
                make.top.equalTo(precipitationView.snp.top).offset(10)
                make.leading.equalTo(precipitationView.snp.leading).offset(10)
            }
            precipitationPoint.snp.makeConstraints { make in
                make.top.equalTo(precipitationLabel.snp.bottom).offset(10)
                make.leading.equalTo(precipitationView.snp.leading).offset(10)
            }
            precipitationDescriptionLabel.snp.makeConstraints { make in
                make.leading.equalTo(precipitationView.snp.leading).offset(10)
                make.trailing.equalTo(precipitationView.snp.trailing).offset(-10)
                make.bottom.equalTo(precipitationView.snp.bottom).offset(-10)
            }
        }

        feelsLikeView.snp.makeConstraints { make in
            make.width.equalTo(180)
            make.height.equalTo(150)
            make.top.equalTo(windSpeedView.snp.bottom).offset(10)
            make.leading.equalTo(contentView.snp.leading).offset(20)

            feelsLikeLabel.snp.makeConstraints { make in
                make.top.equalTo(feelsLikeView.snp.top).offset(10)
                make.leading.equalTo(feelsLikeView.snp.leading).offset(10)
            }
            feelsLikePoint.snp.makeConstraints { make in
                make.top.equalTo(feelsLikeLabel.snp.bottom).offset(10)
                make.leading.equalTo(feelsLikeView.snp.leading).offset(10)
            }
            feelsLikeDescriptionLabel.snp.makeConstraints { make in
                make.leading.equalTo(feelsLikeView.snp.leading).offset(10)
                make.trailing.equalTo(feelsLikeView.snp.trailing).offset(-10)
                make.bottom.equalTo(feelsLikeView.snp.bottom).offset(-10)
            }
        }

        humidityView.snp.makeConstraints { make in
            make.width.equalTo(180)
            make.height.equalTo(150)
            make.top.equalTo(windSpeedView.snp.bottom).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)

            humidityLabel.snp.makeConstraints { make in
                make.top.equalTo(humidityView.snp.top).offset(10)
                make.leading.equalTo(humidityView.snp.leading).offset(10)
            }
            humidityPoint.snp.makeConstraints { make in
                make.top.equalTo(humidityLabel.snp.bottom).offset(10)
                make.leading.equalTo(humidityView.snp.leading).offset(10)
            }
            dewPointDescriptionLabel.snp.makeConstraints { make in
                make.leading.equalTo(humidityView.snp.leading).offset(10)
                make.trailing.equalTo(humidityView.snp.trailing).offset(-10)
                make.bottom.equalTo(humidityView.snp.bottom).offset(-10)
            }
        }

        visibilityView.snp.makeConstraints { make in
            make.width.equalTo(180)
            make.height.equalTo(150)
            make.top.equalTo(feelsLikeView.snp.bottom).offset(10)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.bottom.equalTo(contentView.snp.bottom).offset(-55)

            visibilityLabel.snp.makeConstraints { make in
                make.top.equalTo(visibilityView.snp.top).offset(10)
                make.leading.equalTo(visibilityView.snp.leading).offset(10)
            }
            visibilityPoint.snp.makeConstraints { make in
                make.top.equalTo(visibilityLabel.snp.bottom).offset(10)
                make.leading.equalTo(visibilityView.snp.leading).offset(10)
            }
            visibilityDescriptionLabel.snp.makeConstraints { make in
                make.leading.equalTo(visibilityView.snp.leading).offset(10)
                make.trailing.equalTo(visibilityView.snp.trailing).offset(-10)
                make.bottom.equalTo(visibilityView.snp.bottom).offset(-10)
            }
        }

        pressureView.snp.makeConstraints { make in
            make.width.equalTo(180)
            make.height.equalTo(150)
            make.top.equalTo(humidityView.snp.bottom).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
            make.bottom.equalTo(contentView.snp.bottom).offset(-55)

            pressureLabel.snp.makeConstraints { make in
                make.top.equalTo(pressureView.snp.top).offset(10)
                make.leading.equalTo(pressureView.snp.leading).offset(10)
            }
            pressurePoint.snp.makeConstraints { make in
                make.top.equalTo(pressureLabel.snp.bottom).offset(10)
                make.leading.equalTo(pressureView.snp.leading).offset(10)
            }
        }

        pageControl.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }

        locationListButton.snp.makeConstraints { make in
            make.centerY.equalTo(pageControl.snp.centerY)
            make.trailing.equalTo(pageControl.snp.trailing).offset(-20)
        }

        hourlyCollectionView.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: HourlyCollectionViewCell.identifier)
        dailyTableView.register(DailyTableViewCell.self, forCellReuseIdentifier: DailyTableViewCell.identifier)
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // 포그라운드 일 때 위치 추적 요청
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 배터리에 맞게 권장되는 최적의 정확도
        locationManager.startUpdatingLocation() // 위치 업데이트

        let coor = locationManager.location?.coordinate
        lat = coor?.latitude
        lon = coor?.longitude

        if isAddCityView == true {
            fetchWeatherData(lat: searchLat ?? 0.0, lon: searchLon ?? 0.0)
            self.currentLocationLabel.text = searchedLocality
        } else if isAddCityView == false {
            fetchWeatherData(lat: lat ?? 0.0, lon: lon ?? 0.0)

            if let lat = lat, let lon = lon {
                let findLocation: CLLocation = CLLocation(latitude: lat, longitude: lon)
                let geoCoder = CLGeocoder()
                let locale = Locale(identifier: "Ko-kr") // ko-kr로 하면 '서울' 출력, 하지 않으면 'Seoul' 출력됨
                geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: locale) { placemark, error in
                    if let address: [CLPlacemark] = placemark {
                        let locality = address.last?.locality
                        if let local = locality.map({ $0 }) {
                            let resultOfLocality = local.reduce("") { return "\($0)" + "\($1)" }

                            self.myLocality = resultOfLocality
                            self.currentLocationLabel.text = self.myLocality
                        }
                    }
                }
            }
        }
    }

    func setupPageControl() {
        pageControl.numberOfPages = cityList.count
        pageControl.setIndicatorImage(UIImage(systemName: "location.fill"), forPage: 0)
    }

    func setupAnimationView() {
        animationView.loopMode = .loop
        animationView.play()
    }

    func mainTopConfigureUI() {
        let daily = dailyWeather.first

        if let temp = current?.temp, let main = current?.weather[0].main, let max = daily?.temp?.max, let min = daily?.temp?.min {

            if main == "Clouds" {
                currentMainLabel.text = "흐림"
            } else if main == "Clear" {
                currentMainLabel.text = "맑음"
            } else if main == "Snow" {
                currentMainLabel.text = "눈"
            } else {
                currentMainLabel.text = main
            }

            currentTempLabel.text = "\(String(temp).convertCelsius(temp: temp))°"
            maxTempLabel.text = "최고:\(String(max).convertCelsius(temp: max))°"
            minTempLabel.text = "최저:\(String(min).convertCelsius(temp: min))°"
        }
    }

    func setupUviViewAndSunriseView() {
        if let uvi = current?.uvi, let sunrise = current?.sunrise, let sunset = current?.sunset {
            uviPoint.text = String(Int(uvi))
            if uvi < 5 {
                uviDescriptionLabel.text = "남은 하루 동안 자외선 지수가 낮겠습니다."
            } else {
                uviDescriptionLabel.text = "남은 하루 동안 자외선 지수가 높겠습니다."
            }

            sunriseTimeLabel.text = String(sunrise).nowTime("HH:mm", timezone_offset!)
            sunsetTimeLabel.text = "일몰: \(String(sunset).nowTime("HH:mm", timezone_offset!))"
        }
    }

    func setupWindSpeedViewAndPrecipitationView() {
        if let speed = current?.windSpeed, let rain = daily?.rain {
            windSpeedPoint.text = "\(Int(floor(speed)))m/s"
            precipitationPoint.text = "\(rain)mm"
        }
    }

    func setupFeelsLikeViewAndHumidityView() {
        if let temp = current?.temp, let feelsLike = current?.feelsLike, let humidity = current?.humidity, let dewPoint = current?.dewPoint {
            let compareTemp = abs(temp - feelsLike)
            if 0...5 ~= compareTemp {
                feelsLikeDescriptionLabel.text = "실제 온도와 비슷합니다."
            } else if 6...10 ~= compareTemp {
                feelsLikeDescriptionLabel.text = "실제 온도보다 더 선선합니다."
            }

            feelsLikePoint.text = "\(String(feelsLike).convertCelsius(temp: feelsLike))°"
            humidityPoint.text = "\(humidity)%"
            dewPointDescriptionLabel.text = "현재 이슬점이 \(String(dewPoint).convertCelsius(temp: dewPoint))°입니다."
        }
    }

    func setupVisibilityViewAndPressureView() {
        if let visibility = current?.visibility, let pressure = current?.pressure {
            let convertKirometer = visibility / 1000

            if convertKirometer > 15 {
                visibilityDescriptionLabel.text = "현재 매우 좋은 상태입니다."
            } else if 10...15 ~= convertKirometer {
                visibilityDescriptionLabel.text = "현재 가시거리는 보통입니다."
            } else {
                visibilityDescriptionLabel.text = "현재 가시거리는 매우 나쁩니다."
            }
            visibilityPoint.text = "\(convertKirometer)km"
            pressurePoint.text = "\(pressure)hPa"
        }
    }

    // MARK: Actions

    @objc func handlePageControl() {
        print("페이지컨트롤 터치")
    }

    @objc func handleListButton() {
        print("Handled location list button")
        pageControl.isUserInteractionEnabled = false
        let controller = LocationListViewController()
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .overCurrentContext
        self.present(navigationController, animated: true, completion: nil)
    }
}

// MARK: Hourly CollectionView

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyWeather.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifier, for: indexPath) as! HourlyCollectionViewCell
        let hourly = hourlyWeather[indexPath.row]

        if let dt = hourly.dt, let icon = hourly.weather?[0].icon, let temp = hourly.temp, let description = hourlyWeather[0].weather?[0].description {
            let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")

            // TODO: 이거 더 추가해야함... (너무많은데? 이게맞나..?)
            if description == "broken clouds" {
                setupAnimationView()
                animationView.animation = Animation.named("8368-cloud")
                currentDescriptionLabel.text = "구름이 많은 상태가 예상됩니다."
            } else if description == "overcast clouds" {
                setupAnimationView()
                animationView.animation = Animation.named("4800-weather-partly-cloudy")
                currentDescriptionLabel.text = "흐린 상태가 예상됩니다."
            } else if description == "scattered clouds" {
                setupAnimationView()
                animationView.animation = Animation.named("4804-weather-sunny")
                currentDescriptionLabel.text = "일부 맑은 상태가 예상됩니다."
            } else if description == "few clouds" {
                setupAnimationView()
                animationView.animation = Animation.named("4804-weather-sunny")
                currentDescriptionLabel.text = "대부분 맑은 상태가 예상됩니다."
            } else if description == "clear sky" {
                setupAnimationView()
                animationView.animation = Animation.named("4804-weather-sunny")
                currentDescriptionLabel.text = "맑은 상태가 예상됩니다."
            } else {
                currentDescriptionLabel.text = description
            }

            // 해당 시간이 일몰이나 일출일 때 시간값과 온도값을 다르게 표기합니다
            if String(dt).nowTime("H시", timezone_offset!) == String(current!.sunset).nowTime("H시", timezone_offset!) {
                cell.hourlyLabel.text = String(current!.sunset).nowTime("HH:mm", timezone_offset!)
                cell.tempLabel.text = "일몰"
            } else if String(dt).nowTime("H시", timezone_offset!) == String(current!.sunrise).nowTime("H시", timezone_offset!) {
                cell.hourlyLabel.text = String(current!.sunrise).nowTime("HH:mm", timezone_offset!)
                cell.tempLabel.text = "일출"
            } else {
                cell.hourlyLabel.text = String(dt).nowTime("H시", timezone_offset!)
                cell.tempLabel.text = "\(String(temp).convertCelsius(temp: temp))°"
            }

            cell.weatherIconImage.kf.setImage(with: url)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: collectionView.frame.height)
    }
}

// MARK: Daily TableView

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "8일간의 일기예보"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyWeather.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DailyTableViewCell.identifier, for: indexPath) as! DailyTableViewCell
        cell.backgroundColor = .white.withAlphaComponent(0.6)
        let daily = dailyWeather[indexPath.row]

        switch indexPath.row {
        case 0 ... 7:
            if let min = daily.temp?.min, let max = daily.temp?.max, let icon = daily.weather?[0].icon, let dt = daily.dt {
                let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")

                cell.minTempLabel.text = "\(String(min).convertCelsius(temp: min))°"
                cell.maxTempLabel.text = "\(String(max).convertCelsius(temp: max))°"
                cell.weatherIconImage.kf.setImage(with: url)
                cell.dayOfTheWeekLabel.text = String(dt).weekDayFromDate()

                // TODO: 오늘날짜와 비교하여 같으면 요일 레이블에 요일 값이 아닌 '오늘'로 표기되게 해야함
                // TODO: swift에서 Unix TimeStamp값을 print해보면 Weather API의 Unix TimeStamp값과 무조건 다름
                // TODO: Weather API의 dt값이 바로바로 최신화되지 않고 일정시간마다 업데이트 되는 듯함
            }
        default:
            return UITableViewCell()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MainViewController: CLLocationManagerDelegate {

}

extension MainViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(floor(scrollView.contentOffset.x / UIScreen.main.bounds.width))
    }
}

private extension MainViewController {
    func fetchWeatherData(lat: Double, lon: Double) {
        WeatherService().getAllWeatherInfo3(lat: lat, lon: lon) { result in
            switch result {
            case .success(let weatherResponse):
                DispatchQueue.main.async {
                    self.timezone = weatherResponse.timezone
                    self.timezone_offset = weatherResponse.timezoneOffset
                    self.current = weatherResponse.current
                    self.hourly = weatherResponse.hourly.first
                    self.daily = weatherResponse.daily.first
                    self.dailyWeather = weatherResponse.daily
                    self.hourlyWeather = weatherResponse.hourly
                    self.mainTopConfigureUI()
                    self.setupUviViewAndSunriseView()
                    self.setupWindSpeedViewAndPrecipitationView()
                    self.setupFeelsLikeViewAndHumidityView()
                    self.setupVisibilityViewAndPressureView()
                    self.hourlyCollectionView.reloadData()
                    self.dailyTableView.reloadData()
                }
            case .failure(let error):
                print("DEBUG: Occured error in fetchWeatherData: \(error.localizedDescription)")
            }
        }
    }
}
