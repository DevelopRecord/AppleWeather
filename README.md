# AppleWeather
OpenWeatherAPI를 이용하여 애플의 기본 날씨 앱을 만듭니다.

## 목차

[1. 라이브러리](#라이브러리)   
[2. 프레임워크](#프레임워크)   
[3. 미리보기](#미리보기)   
[4. 기능](#기능)   

#### 라이브러리   
|이름|목적|버전|
|:------:|:---:|:---:|
|Alamofire|http 통신|5.0.0|
|Then|직관적이고 깔끔한 인스턴스 생성|2.2.0|
|SnapKit|Auto Layout|5.0.0|
|Kingfisher|URL 이미지 주소를 가진 이미지 불러오기|7.2.0|
|lottie-ios|반복되는 애니메이션 적용|1.9.5|
   
#### 프레임워크
- UIKit
   
#### 미리보기
<img src="https://user-images.githubusercontent.com/76255765/165723339-61c8f520-e245-495f-9653-94c928af0d33.gif" width="250" height="510"/>

#### 기능

* 현재 날씨 정보
  * OpenWeather API의 현재 날씨 정보를 Alamofire로 통신하여 가져옴
  * JSON의 위도, 경도값을 바탕으로 CoreLocation 프레임워크를 사용하여 지역구(동) 정보를 가져옴

* 시간별 날씨 정보
  * OpenWeather API의 시간별 날씨 정보를 Alamofire로 통신하여 가져옴
  * 가로 컬렉션뷰로 스크롤링이 가능하게 구현
  * 일출, 일몰 정보는 다르게 표기

* 일별 날씨 정보
  * OpenWeather API의 일별 날씨 정보를 Alamofire로 통신하여 가져옴
  * 요일, 날씨 상태 아이콘, 최저 및 최고온도 표기

* 대기질, 자외선, 일출(일몰), 풍속, 강우량, 체감온도, 습도, 가시거리, 기압 표기
  * 일별 날씨 정보 하단에 표기

* 도시 또는 공항 검색
  * MapKit 및 MKLocalSearchCompleter 프로퍼티를 사용하여 세계 도시 검색 기능 구현
  * 검색한 도시의 위•경도 값으로 날씨 정보 가져옴

* 배경화면 애니메이션 적용
  * Lottie 프레임워크를 이용하여 JSON 애니메이션을 이용하여 view에 반복되는 애니메이션 적용
