//
//  MapViewController.swift
//  SeSAC2Week6
//
//  Created by Seo Jae Hoon on 2022/08/11.
//

import UIKit
import MapKit

// Location 1. 임포트 2.
import CoreLocation
/*
 MapView
 - 지도와 위치 권한은 상관 없다
 - 만약 지도에 현재 위치 등을 표현하고 싶다면, 위치권한이 필요함
 - MKCoordinateRegion -> 중심, 범위 지정 37.535856, 127.132414
 - 핀(어노테이션) 찍어주기(지도 보여주는 것과 다르다)
 */
/*
 - 권한 : 반영이 조금씩 느릴 수 있음. 지웠다가 실행한다고 하더라도.. 한번 허용으로 처리하면 순서를 확인할 수 있음
 - 설정 : 앱이 바로 안 뜨는 경우도 있을 수 있음.
 */


class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    
    // Location 2. 위치에 대한 대부분을 담당
    let locationMannager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Location 3. 프로토콜 연결
        locationMannager.delegate = self
        
        //checkUserDevideLocationServiceAuthorization()
        // 지도 중심 설정: 애플맵 활용해 좌표 복사
        let center = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
        setRegionAndAnnotation(center: center)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showRequestLocationServiceAlert()
    }
    
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        
        
        // 지도 중심 기반으로 보여질 범위 설정
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "이곳이 나의 집이다."
        
        // 지도에 핀 추가
        mapView.addAnnotation(annotation)
    }

}

// 위치에 관련된 User Defined 메서드
extension MapViewController {
    
    // Location 7. (iOS 버전에 따른 분기처리 및 iOS 위치 서비스 활성화 여부 확인)
    // 위치 서비스가 켜져있다면 권한을 요청하고, 꺼져있다면 커스텀 얼럿으로 상황 알려주기
    // CLAuthorizationStatus
    // - denied: 허용 안함 / 설정에서 추후에 거부한 상황 / 위치 서비스 중지 / 비행기 모드
    // - restricted: 앱에서 권한 자체가 없는 경우 / 자녀 보호 기능 같은걸로 아예 제한
    
    //위치 서비스가 켜져있는지를 확인하는 메서드
    func checkUserDevideLocationServiceAuthorization() {
        
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0 , *) {
            //인스턴스를 통해 locationManager가 가지고 있는 상태를 가져옴
            authorizationStatus = locationMannager.authorizationStatus
            
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        //iOS 위치 서비스 활성화 여부 체크
        if CLLocationManager.locationServicesEnabled() {
            // 위치 서비스가 활성화 되어있으므로, 위치 권한 요청 가능해서 위치 권한 요청을 띄움
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("위치 서비스가 꺼져 있어서 위치 권한 요청을 못합니다.")
        }
    }
    
    // Location 8. 사용자의 위치 권한 상태 확인
    // 사용자가 위치를 허용했는지, 거부했는지, 아직 선택하지 않았는 지 등을 확인(단, 사전에 iOS 위치 서비스 활성화 꼭 확인)
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("NOTDETERMINED")
            
            locationMannager.desiredAccuracy = kCLLocationAccuracyBest
            locationMannager.requestWhenInUseAuthorization() // 앱을 사용하는 동안에 위치 권한 요청
            //plsit에 when in use가 등록이 되어야 위에 request 메서드를 사용할 수 있다.
            //locationMannager.startUpdatingLocation()
            
        case .restricted, .denied :
            print("Denied, 아이폰 설정으로 유도")
        case .authorizedWhenInUse:
            print("WHEN IN USE")
            //사용자가 위치를 허용해둔 상태라면, statUpdatingLocation을 통해 didUpdateLocations 메서드 실행
            locationMannager.startUpdatingLocation()
        default:
            print("DEFAULT")
        }
    }
    
    
   /*
    설정으로 이동하는 
    */
    
    func showRequestLocationServiceAlert() {
      let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
      let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
        
          if let appSetting = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(appSetting)
          }
          
      }
      let cancel = UIAlertAction(title: "취소", style: .default)
      requestLocationServiceAlert.addAction(cancel)
      requestLocationServiceAlert.addAction(goSetting)
      
      present(requestLocationServiceAlert, animated: true, completion: nil)
    }
}





// Location 4. 프로토콜 선언
extension MapViewController: CLLocationManagerDelegate {
    
    //Location 5. didUpdateLocation => 사용자의 위치를 성공적으로 가지고 온 경우에 해당
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
        
        //ex. 위도 경도 기반으로 날씨 정보를 조회
        //ex. 지도를 다시 세팅
        if let coordinate = locations.last?.coordinate {
            
//            let latitude = coordinate.latitude
//            let longitude = coordinate.longitude
//            let center = CLLocationCoordinate2D(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)
            
            setRegionAndAnnotation(center: coordinate)
        }
        
        
        //위치 업데이트 멈춰!
        locationMannager.stopUpdatingLocation()
    }
    
    //Location 6. didFailWithError => 사용자의 위치를 못 가져온 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    //Location 9. 사용자의 권한 상태가 바뀔 때를 알려줌(앱을 처음 실행했을 때도 선언 됨 왜냐면 locationManager() 인스턴스 생성했을 때 처음으로 호출되는 함수이기 때문에)
    // 허용 거부 했다가 설정에서 변경했거나, 혹은 NotDetermined에서 허용을 눌렀거나 등
    // 허용 했어서 위치를 가지고오는 중에, 설정에서 거부하고 돌아온다면??
    // iOS 14 이상: 사용자의 권한 상태가 변경이 될 때, 위치 관리자 생성할 때도 호출됨
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserDevideLocationServiceAuthorization()
    }
    // iOS 14 미만
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
}






extension MapViewController: MKMapViewDelegate {
    
    //지도에 커스텀 핀 추가
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        <#code#>
//    }
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        locationMannager.stopUpdatingLocation()
    }
}
