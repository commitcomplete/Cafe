//
//  FindCafeButton.swift
//  AAonecup
//
//  Created by dohankim on 2022/09/20.
//

import Foundation
import UIKit

final class FindCafeButton : UIButton {
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            self.configureUI()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            self.configureUI()
        }
        
        convenience init(title: String) {
            self.init(frame: .zero)
            self.configureUI(title: title)
        }
    
    
        
}

private extension FindCafeButton {
    func configureUI(title: String = "") {
        self.setTitle("카페 찾기", for: .normal)
        self.backgroundColor = .clear
        self.layer.cornerRadius = 20
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2
        self.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
}
