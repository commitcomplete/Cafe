//
//  FindCafeViewController.swift
//  AAonecup
//
//  Created by dohankim on 2022/09/20.
//

import UIKit
import RxSwift
import SnapKit
import AVFoundation
import CoreLocation
import MapKit

class FindCafeViewController: UIViewController {
    var progressAnimationtimer: Timer? = nil
    var isButtonClicked = false
    let locationManager = CLLocationManager()
    let viewModel = FindCafeViewModel()
    let disposeBag = DisposeBag()
    let iceSound = URL(fileURLWithPath: Bundle.main.path(forResource: "iceSound", ofType: "mp3")!)
    var audioPlayer = AVAudioPlayer()
    let cellId = "CafeTableViewCell"
    var currentCoords: CLLocationCoordinate2D!
    
    lazy var mainTitle: UILabel = {
        let label = UILabel()
        label.text = "Cafe!"
        label.textColor = UIColor(named: "Brown")
        label.font = UIFont.systemFont(ofSize: 60, weight: .bold)
        label.alpha = 0.0
        return label
    }()
    
    lazy var cafeTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.rowHeight = 80
        tableView.alpha = 0.0
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    lazy var coffeeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "iceCoffee")
        return imageView
    }()
    
    lazy var cafeFindButton: UIButton = {
        let findButton: UIButton = UIButton()
        findButton.backgroundColor = UIColor(named: "Brown")
        findButton.setTitle(" 카페 찾기", for: .normal)
        findButton.setTitleColor(.systemGray, for: .highlighted)
        findButton.setTitleColor(UIColor(named: "disableTextColor"), for: .disabled)
        findButton.layer.cornerRadius = 10
        findButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        findButton.setImage(UIImage(systemName: "paperplane.fill")?.withRenderingMode(.alwaysTemplate), for: .disabled)
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
        bindingObject()
        // MARK: todo
        // 앱껐다가 들어올시에 재사용 대기시간 초기화 방지
        //        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //        var startItem = UserDefaults.standard.value(forKey: "nowDate")
        //        if Int(Date().timeIntervalSince(startItem as! Date)) < 60 {
        //            viewModel.limitSearchTime(inputSeconds: Int(Date().timeIntervalSince(startItem as! Date)))
        //        }
    }
}

extension FindCafeViewController {
    
    func pushNavi(route: MKRoute , coords: CLLocationCoordinate2D, cafeName:String, address: String ,distance: Int){
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
                UIView.animate(withDuration: 0.1) {
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
    
    func playIceSound() {
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: self.iceSound)
            self.audioPlayer.play()
        } catch {
            print("error")
        }
    }
    
    @objc func imageTouchAnimation(_ sender: UITapGestureRecognizer) {
        playIceSound()
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
    
    func buttonTouchAnimation() {
        cafeFindButton.setTitle("탐색중...", for: .normal)
        cafeFindButton.isEnabled = false
        cafeFindButton.tintColor = UIColor(named: "disableTextColor")
        cafeFindButton.setImage(UIImage(systemName: ""), for: .normal)
        UIView.animate(withDuration: 0.7) {
            self.mainTitle.alpha = 0.0
            self.cafeTableView.alpha = 0.0
        }
        progressAnimationtimer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { _ in
            self.progressAnimation()
        }
    }
    
    func progressAnimation() {
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
    
    func scrollToTop() {
        let topRow = IndexPath(row: 0,
                               section: 0)
        self.cafeTableView.scrollToRow(at: topRow,
                                       at: .top,
                                       animated: true)
    }
    
    // MARK: Layout
    func setUpLayOut() {
        view.backgroundColor = UIColor(named: "AccentColor")
        view.addSubview(coffeeImageView)
        view.addSubview(cafeTableView)
        view.addSubview(cafeFindButton)
        view.addSubview(mainTitle)
        setUpTableView()
        if UIScreen.main.bounds.height < 700 {
            mainTitle.font = UIFont.boldSystemFont(ofSize: 60)
        }else if UIScreen.main.bounds.height < 800{
            mainTitle.font = UIFont.boldSystemFont(ofSize: 70)
        }
        else{
            mainTitle.font = UIFont.boldSystemFont(ofSize: 90)
        }
        mainTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
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
                make.top.equalToSuperview().offset(50)
            }
            
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTouchAnimation))
        coffeeImageView.addGestureRecognizer(tapGesture)
        coffeeImageView.isUserInteractionEnabled = true
        cafeFindButton.rx.tap.bind {
            self.isButtonClicked = true
            self.checkLocationPermission()
            
        }
        .disposed(by: disposeBag)
    }
    
}
