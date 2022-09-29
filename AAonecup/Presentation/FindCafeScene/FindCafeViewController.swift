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

class FindCafeViewController : UIViewController{
    let viewModel = FindCafeViewModel()
    let disposeBag = DisposeBag()
    let iceSound = URL(fileURLWithPath: Bundle.main.path(forResource: "iceSound", ofType: "mp3")!)
    var audioPlayer = AVAudioPlayer()

    
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
        setUpLayOut()
        introAnimationWithSound()

    }
    
}

extension FindCafeViewController{
    func setUpLayOut(){
        view.backgroundColor = UIColor(named: "AccentColor")
        view.addSubview(coffeeImageView)
        view.addSubview(cafeFindButton)
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
    
}
