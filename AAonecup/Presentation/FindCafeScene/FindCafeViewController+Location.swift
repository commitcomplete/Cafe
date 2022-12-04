//
//  FindViewController+Location.swift
//  AAonecup
//
//  Created by dohankim on 2022/11/23.
//

import Foundation
import CoreLocation
import UIKit

//MARK: Location
extension FindCafeViewController:CLLocationManagerDelegate {
    func setUpCLLocation() {
        //델리게이트 설정
        locationManager.delegate = self
        // 거리 정확도 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 사용자에게 허용 받기 alert 띄우기
        
    }
    
    func checkLocationPermission() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted,.denied:
            sendLocationPermissionAlert()
        case .authorizedAlways ,.authorizedWhenInUse:
            let longtitude = locationManager.location?.coordinate.longitude ?? 126.584063
            let langtitude = locationManager.location?.coordinate.latitude ?? 37.335887
            viewModel.currentCoord = CLLocationCoordinate2D(latitude: langtitude, longitude: longtitude)
            viewModel.getNearCafeList(currentCoord: locationManager.location!.coordinate)
            buttonTouchAnimation()
        @unknown default:
            break
        }
    }
    
    func sendLocationPermissionAlert() {
        //Alert 생성 후 액션 연결
        let alertController = UIAlertController(title: "위치 서비스를 사용할 수 없습니다. 기기의 위치서비스를 켜주세요.(필수권한)", message: "앱 설정 화면으로 이동하시겠습니까?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "아니오", style: .destructive, handler: { (action) -> Void in
            
        }))
        alertController.addAction(UIAlertAction(title: "네", style: .default, handler: { (action) -> Void in
            
            if let appSettings = URL(string: UIApplication.openSettingsURLString){
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied,.restricted:
            break
        case .authorizedWhenInUse,.authorizedAlways:
            if self.isButtonClicked {
                let longtitude = locationManager.location?.coordinate.longitude ?? 126.584063
                let langtitude = locationManager.location?.coordinate.latitude ?? 37.335887
                viewModel.currentCoord = CLLocationCoordinate2D(latitude: langtitude, longitude: longtitude)
                viewModel.getNearCafeList(currentCoord: locationManager.location!.coordinate)
                buttonTouchAnimation()
            }
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
}
