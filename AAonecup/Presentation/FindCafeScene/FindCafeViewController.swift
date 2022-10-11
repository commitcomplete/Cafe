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
import MapKit

class FindCafeViewController : UIViewController {
    var progressAnimationtimer: Timer? = nil
    var isButtonClicked = false
    let locationManager = CLLocationManager()
    let viewModel = FindCafeViewModel()
    let disposeBag = DisposeBag()
    let iceSound = URL(fileURLWithPath: Bundle.main.path(forResource: "iceSound", ofType: "mp3")!)
    var audioPlayer = AVAudioPlayer()
    let cellId = "CafeTableViewCell"
    var currentCoords : CLLocationCoordinate2D!
    
    
    private lazy var mainTitle : UILabel = {
        let label = UILabel()
        label.text = "Cafe!"
        label.textColor = UIColor(named: "Brown")
        label.font = UIFont.systemFont(ofSize: 60, weight: .bold)
        label.alpha = 0.0
        return label
    }()
    private lazy var cafeTableView : UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.rowHeight = 80
        tableView.alpha = 0.0
        tableView.showsVerticalScrollIndicator = false
        return tableView
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
        findButton.setTitleColor(.systemGray, for: .highlighted)
        findButton.layer.cornerRadius = 10
        findButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        findButton.tintColor = .white
        findButton.insetsLayoutMarginsFromSafeArea = true
        findButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        findButton.alpha = 0.0
        return findButton
    }()
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCLLocation()
        setUpLayOut()
        introAnimationWithSound()
        bindingObject()
    }
    
}

extension FindCafeViewController{
    // MARK: Binding
    func bindingObject(){
        viewModel.cafeListObservable
            .observe(on: MainScheduler.instance)
            .bind(to: cafeTableView.rx.items(cellIdentifier: cellId, cellType: CafeTableViewCell.self)){
                index, item, cell in
                print(item.cafeName)
                cell.cafeNameLabel.text = item.cafeName
                    .replacingOccurrences(of: "<b>", with:" ")
                    .replacingOccurrences(of: "</b>", with:" ")
                cell.cafeAddressLabel.text = item.cafeAddress
                cell.cafeDistance.text = "\(Double(item.distance).prettyDistance)"
            }
            .disposed(by: disposeBag)
        
        viewModel.isSearchLimitTimeIsOver
            .observe(on: MainScheduler.instance)
            .subscribe { remainSecond in
                self.cafeFindButton.setTitle("로스팅중 \(remainSecond.element ?? 60)", for: .normal)
            }
        
        cafeTableView.rx.modelSelected(CafeInfo.self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {item in
                self.pushNavi(route: item.route, coords: item.coords,cafeName: item.cafeName,address: item.cafeAddress,distance : item.distance)
            })
            .disposed(by: disposeBag)
        
        cafeTableView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .subscribe { index in
                self.cafeTableView.deselectRow(at: index, animated: true)
            }
        viewModel.isProgressAnimationContinue.bind{
            if $0{
                self.progressAnimationtimer?.invalidate()
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.6) {
                        self.cafeTableView.alpha = 1.0
                        self.coffeeImageView.alpha = 0.3
                    }
                    self.viewModel.limitSearchTime()
//                    self.cafeFindButton.setTitle("커피 식히는중...", for: .normal)
//                    Timer.scheduledTimer(withTimeInterval: 60.0, repeats: false) { _ in
//                        self.cafeFindButton.setTitle(" 재탐색하기", for: .normal)
//                        self.cafeFindButton.isEnabled = true
//                        self.cafeFindButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
//                    }
                    
                }
            }
        }
        
        viewModel.isProgressOutOfTime.bind{
            if $0{
                self.progressAnimationtimer?.invalidate()
                self.viewModel.cafeListObservable.onNext([CafeInfo]())
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.6) {
                        self.cafeTableView.alpha = 1.0
                        self.coffeeImageView.alpha = 0.3
                    }
                    self.cafeFindButton.setTitle("커피 식히는중...", for: .normal)
                    self.mainTitle.text = "No Cafe!"
                    self.mainTitle.alpha = 1.0
                    Timer.scheduledTimer(withTimeInterval: 60.0, repeats: false) { _ in
                        self.cafeFindButton.setTitle(" 재탐색하기", for: .normal)
                        self.cafeFindButton.isEnabled = true
                        self.cafeFindButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
                        
                    }
                    
                }
            }
            
        }
    }
    // MARK: Layout
    func setUpLayOut(){
        view.backgroundColor = UIColor(named: "AccentColor")
        view.addSubview(coffeeImageView)
        view.addSubview(cafeTableView)
        view.addSubview(cafeFindButton)
        view.addSubview(mainTitle)
        setUpTableView()
        mainTitle.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            if UIScreen.main.bounds.height < 700{
                $0.top.equalToSuperview().inset(25)
            }else if UIScreen.main.bounds.height < 800{
                $0.top.equalToSuperview().inset(40)
            }
            else{
                $0.top.equalToSuperview().inset(80)
            }
            
        }
        coffeeImageView.snp.makeConstraints{make in
            make.center.equalToSuperview()
            make.width.equalTo(270)
            make.height.equalTo(385)
        }
        cafeFindButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            if UIScreen.main.bounds.height<800{
                make.bottom.equalToSuperview().inset(20)
            }
            else{
                make.bottom.equalToSuperview().inset(60)}
            make.height.equalTo(48)
        }
        cafeTableView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            if UIScreen.main.bounds.height < 800{
                make.bottom.equalToSuperview().inset(80)
                make.top.equalToSuperview().offset(30)
            }
            else{
                make.bottom.equalToSuperview().inset(160)
                make.top.equalToSuperview().offset(30)
            }
            
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
    func pushNavi(route : MKRoute , coords : CLLocationCoordinate2D, cafeName :String, address: String ,distance : Int){
        let cafeRouteViewController = CafeRouteViewController()
        cafeRouteViewController.myCoordinates = locationManager.location?.coordinate
        cafeRouteViewController.placeString1 = cafeName
        cafeRouteViewController.placeString2 = address
        cafeRouteViewController.route = route
        cafeRouteViewController.coords = coords
        cafeRouteViewController.currentDistance = distance
        self.navigationController?.pushViewController(cafeRouteViewController, animated: true)
    }
    
    func setUpTableView(){
        cafeTableView.dataSource = nil
        cafeTableView.register(CafeTableViewCell.self, forCellReuseIdentifier: cellId)
        cafeTableView.isScrollEnabled = true
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
//        UIView.animate(withDuration: 0.1) {
//            let rotate = CGAffineTransform(rotationAngle: .pi)
//            self.coffeeImageView.transform = rotate
//        } completion: { _ in
//            UIView.animate(withDuration: 0.1) {
//                let rotate = CGAffineTransform(rotationAngle: .zero)
//                self.coffeeImageView.transform = rotate
//            }
//        }
        
        UIView.animate(withDuration: 0.2) {
            self.coffeeImageView.transform = CGAffineTransform(rotationAngle: .pi)
        }
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: UIView.AnimationOptions.curveEaseIn
        ) {
            self.coffeeImageView.transform = CGAffineTransform(rotationAngle: 2 * .pi)
        }
    }
    func buttonTouchAnimation(){
        cafeFindButton.setTitle("탐색중...", for: .normal)
        cafeFindButton.isEnabled = false
        cafeFindButton.setImage(UIImage(systemName: ""), for: .normal)
        UIView.animate(withDuration: 0.7) {
            self.mainTitle.alpha = 0.0
            self.cafeTableView.alpha = 0.0
        }
        progressAnimationtimer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { _ in
            self.progressAnimation()
        }
        
    }
    
    func progressAnimation(){
        playIceSound()
        self.coffeeImageView.alpha = 1.0
        UIView.animate(withDuration: 0.2) {
            self.coffeeImageView.transform = CGAffineTransform(rotationAngle: .pi)
        }
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: UIView.AnimationOptions.curveEaseIn
        ) {
            self.coffeeImageView.transform = CGAffineTransform(rotationAngle: 2 * .pi)
        }
    }
}

//MARK: Location
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
            let longtitude = locationManager.location?.coordinate.longitude ?? 126.584063
            let langtitude = locationManager.location?.coordinate.latitude ?? 37.335887
            viewModel.currentCoord = CLLocationCoordinate2D(latitude: langtitude, longitude: longtitude)
            viewModel.getNearCafeList(currentCoord: locationManager.location!.coordinate)
            buttonTouchAnimation()
        @unknown default:
            break
        }
        
    }
    
    func getCurrentPlaceName(){
        let longtitude = locationManager.location?.coordinate.longitude ?? 126.584063
        let langtitude = locationManager.location?.coordinate.latitude ?? 37.335887
        let currentLocation = CLLocation(latitude: langtitude, longitude: longtitude)
        viewModel.currentCoord = CLLocationCoordinate2D(latitude: langtitude, longitude: longtitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geocoder.reverseGeocodeLocation(currentLocation, preferredLocale: locale) { [weak self] placemarks, _ in
            guard let placemarks = placemarks,
                  let address = placemarks.last
            else { return }
            var currentPlaceCafeQuery = ""
            
            if address.locality == nil{
                currentPlaceCafeQuery = (address.administrativeArea ?? "서울")+(address.subLocality ?? " 종로구")+" 카페"
            }else{
                currentPlaceCafeQuery = (address.locality ?? "")+(address.subLocality ?? " 종로구")+" 카페"
            }
            //            let searchr = MKLocalSearch.Request()
            //            searchr.naturalLanguageQuery = "cafe"
            //            searchr.region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(langtitude, longtitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            //            let search = MKLocalSearch(request: searchr)
            //            search.start { (response, error) in
            //                guard let response = response else {
            //                    // Handle the error.
            //                    return
            //                }
            //
            //                for item in response.mapItems {
            //                    if let name = item.placemark.title,
            //                        let location = item.placemark.location {
            //                        print("\(name): \(location.coordinate.latitude),\(location.coordinate.longitude)")
            //                    }
            //                }
            //            }
            print(currentPlaceCafeQuery)
            //            self?.viewModel.getCafeList(query: currentPlaceCafeQuery)
            
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
    
    
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus{
        case .denied,.restricted:
            break
        case .authorizedWhenInUse,.authorizedAlways:
            if self.isButtonClicked{
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

