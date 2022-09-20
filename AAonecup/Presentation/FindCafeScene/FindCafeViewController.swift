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
    }
    
    func setBackGroundColor(){
        self.view.backgroundColor = UIColor(named: "AccentColor")
    }
    
    
}
