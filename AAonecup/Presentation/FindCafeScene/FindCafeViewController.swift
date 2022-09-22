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

class FindCafeViewController : UIViewController{
    let viewModel = FindCafeViewModel()
    let disposeBag = DisposeBag()

    private lazy var coffeeImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.layer.masksToBounds = true
            imageView.tintColor = .systemGray5
            imageView.image = UIImage(named: "iceCoffee")
            return imageView
        }()
    
       private lazy var label1: UILabel = {
            let label: UILabel = UILabel()
            label.backgroundColor = .white.withAlphaComponent(0.3)
            label.textColor = .white
            label.font = .systemFont(ofSize: 20, weight: .regular)
            label.text = "cell1"
            label.numberOfLines = 0
            label.layer.masksToBounds = true
            label.shadowColor = .gray
            label.textAlignment = .center
            label.snp.makeConstraints{make in
                make.height.equalTo(100)
                make.width.equalTo(300)
            }
            return label
        }()
    
    private lazy var label2: UILabel = {
         let label: UILabel = UILabel()
        label.backgroundColor = .white.withAlphaComponent(0.3)
         label.textColor = .white
         label.font = .systemFont(ofSize: 20, weight: .regular)
         label.text = "cell2"
         label.numberOfLines = 0
         label.layer.masksToBounds = true
         label.shadowColor = .gray
         label.textAlignment = .center
         label.snp.makeConstraints{make in
             make.height.equalTo(100)
             make.width.equalTo(300)
         }
         return label
     }()
    
    private lazy var label3: UILabel = {
         let label: UILabel = UILabel()
         label.backgroundColor = .white.withAlphaComponent(0.3)
         label.textColor = .white
         label.font = .systemFont(ofSize: 20, weight: .regular)
         label.text = "cell3"
         label.numberOfLines = 0
         label.layer.masksToBounds = true
         label.shadowColor = .gray
         label.textAlignment = .center
         label.snp.makeConstraints{make in
             make.height.equalTo(100)
             make.width.equalTo(300)
         }
         return label
     }()
    
    private lazy var label4: UILabel = {
         let label: UILabel = UILabel()
         label.backgroundColor = .white.withAlphaComponent(0.3)
         label.textColor = .white
         label.font = .systemFont(ofSize: 20, weight: .regular)
         label.text = "cell4"
         label.numberOfLines = 0
         label.layer.masksToBounds = true
         label.shadowColor = .gray
         label.textAlignment = .center
         label.snp.makeConstraints{make in
             make.height.equalTo(100)
             make.width.equalTo(300)
         }
         return label
     }()
    
    private lazy var label5: UILabel = {
         let label: UILabel = UILabel()
         label.backgroundColor = .white.withAlphaComponent(0.3)
         label.textColor = .white
         label.font = .systemFont(ofSize: 20, weight: .regular)
         label.text = "cell 5"
         label.numberOfLines = 0
         label.layer.masksToBounds = true
         label.shadowColor = .gray
         label.textAlignment = .center
         label.snp.makeConstraints{make in
             make.height.equalTo(100)
             make.width.equalTo(300)
         }
         return label
     }()
    
    private lazy var coffeeStackView : UIStackView = {
        let stackView  = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.addArrangedSubview(label1)
        stackView.addArrangedSubview(label2)
        stackView.addArrangedSubview(label3)
        stackView.addArrangedSubview(label4)
        stackView.addArrangedSubview(label5)
        return stackView
    }()
    
    func makeStackView() -> UIStackView{
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.firstJoke
            .observe(on: MainScheduler.instance)
            .bind(to:label2.rx.text)
            .disposed(by: disposeBag)
        viewModel.firstJokeurl
            .bind(to: label3.rx.text)
            .disposed(by: disposeBag)
        view.addSubview(coffeeImageView)
        view.addSubview(coffeeStackView)
        setBackGroundColor()
        setButtonConfigure()
        coffeeImageView.snp.makeConstraints{make in
            make.center.equalToSuperview()
            make.height.equalTo(500)
            make.width.equalTo(300)
        }
      
        coffeeStackView.snp.makeConstraints{make in
            make.center.equalToSuperview()
        }
    
    }
    
    
    
}

extension FindCafeViewController{
    
    func setBackGroundColor(){
        self.view.backgroundColor = UIColor(named: "AccentColor")
    }
    
    func makeCafeFindButton() -> UIButton{
        let button = UIButton()
        button.setTitle("카페 찾기", for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        return button
    }
    
    func setButtonConfigure(){
        let findButton = makeCafeFindButton()
        self.view.addSubview(findButton)
        findButton.snp.makeConstraints{make in
            make.width.equalTo(200)
            make.height.equalTo(100)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
        }
       
        findButton.rx.tap
            .bind{
               self.viewModel.onTapButton()
                }
            .disposed(by: disposeBag)
    }
    
}
