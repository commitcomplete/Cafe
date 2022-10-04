//
//  FindCafeViewController.swift
//  AAonecup
//
//  Created by dohankim on 2022/09/20.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxRelay
import SnapKit
import AVFoundation
import CoreLocation

class FindCafeViewController : UIViewController {
    var isButtonClicked = false
    let locationManager = CLLocationManager()
    let viewModel = FindCafeViewModel()
    let disposeBag = DisposeBag()
    let iceSound = URL(fileURLWithPath: Bundle.main.path(forResource: "iceSound", ofType: "mp3")!)
    var audioPlayer = AVAudioPlayer()
    
    private lazy var mainTitle : UILabel = {
        let label = UILabel()
        label.text = "아아,한잔"
        label.textColor = UIColor(named: "Brown")
        label.font = UIFont.systemFont(ofSize: 60, weight: .bold)
        label.alpha = 0.0
        return label
    }()
    private lazy var coffeeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "iceCoffee")
        return imageView
    }()
    
    private lazy var cafeFindButton : UIButton = {
        let findButton : UIButton = UIButton()
        findButton.backgroundColor = UIColor(named: "Brown")
        findButton.setTitle(" 카페 찾기", for: .normal)
        findButton.setTitle(" 카페 찾기", for: .selected)
        findButton.layer.cornerRadius = 10
        findButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        findButton.tintColor = .white
        findButton.insetsLayoutMarginsFromSafeArea = true
        findButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        findButton.alpha = 0.0
        return findButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCLLocation()
        setUpLayOut()
        introAnimationWithSound()
        viewModel.cafeListObservable
            .debug()
            .map{
                $0[0].address
            }
            .bind(to: mainTitle.rx.text)
            .disposed(by: disposeBag)
    }
    
}

extension FindCafeViewController{
    
    func setUpLayOut(){
        view.backgroundColor = UIColor(named: "AccentColor")
        view.addSubview(coffeeImageView)
        view.addSubview(cafeFindButton)
        view.addSubview(mainTitle)
        mainTitle.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(100)
        }
        coffeeImageView.snp.makeConstraints{make in
            make.center.equalToSuperview()
            make.width.equalTo(270)
            make.height.equalTo(385)
        }
        cafeFindButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(80)
            make.height.equalTo(48)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTouchAnimation))
        coffeeImageView.addGestureRecognizer(tapGesture)
        coffeeImageView.isUserInteractionEnabled = true
        cafeFindButton.rx.tap.bind{
            self.isButtonClicked = true
            self.checkLocationPermission()
            
        }
        .disposed(by: disposeBag)
    }
    
    
    func introAnimationWithSound(){
        playIceSound()
        UIView.animate(withDuration: 0.2) {
            let rotate = CGAffineTransform(rotationAngle: .pi * 0.1)
            self.coffeeImageView.transform = rotate
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                let rotate = CGAffineTransform(rotationAngle: -.pi * 0.1)
                self.coffeeImageView.transform = rotate
            }completion: { _ in
                UIView.animate(withDuration: 0.1){
                    let rotate = CGAffineTransform(rotationAngle: .zero)
                    self.coffeeImageView.transform = rotate
                    
                }completion: { _ in
                    UIView.animate(withDuration: 0.8) {
                        self.cafeFindButton.alpha = 1.0
                        self.mainTitle.alpha = 1.0
                    }
                }
            }
        }
    }
    func playIceSound(){
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: self.iceSound)
            self.audioPlayer.play()
            
        } catch {
            print("error")
        }
    }
    
    @objc func imageTouchAnimation(_ sender: UITapGestureRecognizer){
        playIceSound()
        UIView.animate(withDuration: 0.1) {
            let rotate = CGAffineTransform(rotationAngle: .pi)
            self.coffeeImageView.transform = rotate
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                let rotate = CGAffineTransform(rotationAngle: .zero)
                self.coffeeImageView.transform = rotate
            }
        }
    }
    func buttonTouchAnimation(){
        cafeFindButton.setTitle("탐색중...", for: .normal)
        cafeFindButton.isEnabled = false
        cafeFindButton.setImage(UIImage(systemName: ""), for: .normal)
        UIView.animate(withDuration: 0.7) {
            self.mainTitle.alpha = 0.7
        }
        let _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.progressAnimation()
        }
        
    }
    
    func progressAnimation(){
        playIceSound()
        UIView.animate(withDuration: 0.2) {
            let rotate = CGAffineTransform(rotationAngle: .pi * 0.1)
            self.coffeeImageView.transform = rotate
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                let rotate = CGAffineTransform(rotationAngle: -.pi * 0.1)
                self.coffeeImageView.transform = rotate
            }completion: { _ in
                UIView.animate(withDuration: 0.1){
                    let rotate = CGAffineTransform(rotationAngle: .zero)
                    self.coffeeImageView.transform = rotate
                    
                }
            }
        }
    }
}

//    func setButtonConfigure(){
//        let findButton = makeCafeFindButton()
//        self.view.addSubview(findButton)
//        findButton.snp.makeConstraints{make in
//            make.width.equalTo(200)
//            make.height.equalTo(100)
//            make.centerX.equalToSuperview()
//            make.bottom.equalToSuperview().inset(100)
//        }
//
//        findButton.rx.tap
//            .bind{
////               self.viewModel.onTapButton()
//                LoadSEARCHnewsAPI.shared.requestAPIToNaver(queryValue: "경상북도 포항시 남구 카페")
//                }
//            .disposed(by: disposeBag)
//    }
extension FindCafeViewController :CLLocationManagerDelegate{
    func setUpCLLocation(){
        //델리게이트 설정
        locationManager.delegate = self
        // 거리 정확도 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 사용자에게 허용 받기 alert 띄우기
        
    }
    
    func checkLocationPermission(){
        switch CLLocationManager.authorizationStatus(){
        case .notDetermined :
            locationManager.requestWhenInUseAuthorization()
        case .restricted,.denied:
            sendLocationPermissionAlert()
        case .authorizedAlways ,.authorizedWhenInUse :
            getCurrentPlaceName()
            buttonTouchAnimation()
        @unknown default:
            break
        }
        
    }
    
    func getCurrentPlaceName(){
        let longtitude = locationManager.location?.coordinate.longitude ?? 131
        let langtitude = locationManager.location?.coordinate.latitude ?? 37
        let currentLocation = CLLocation(latitude: langtitude, longitude: longtitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geocoder.reverseGeocodeLocation(currentLocation, preferredLocale: locale) { [weak self] placemarks, _ in
            guard let placemarks = placemarks,
                  let address = placemarks.last
            else { return }
            var currentPlaceCafeQuery = (address.locality ?? "서울")+(address.subLocality ?? "종로구")+"카페"
            
            self?.viewModel.getCafeList(query: currentPlaceCafeQuery)
            
        }
    }
    func sendLocationPermissionAlert(){
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus{
        case .denied,.restricted:
            break
        case .authorizedWhenInUse,.authorizedAlways:
            if self.isButtonClicked{
                getCurrentPlaceName()
                buttonTouchAnimation()
            }
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
}

