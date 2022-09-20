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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackGroundColor()
        setButtonConfigure()
    }
    
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
    }
    
}
