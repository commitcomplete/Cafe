//
//  CafeTableViewCell.swift
//  AAonecup
//
//  Created by dohankim on 2022/10/04.
//

import Foundation
import UIKit
import SnapKit

class CafeTableViewCell : UITableViewCell{
        let cafeAddressLabel = UILabel()
        let cafeNameLabel = UILabel()
        let cafeDistance = UILabel()
    
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.backgroundColor = .clear
            cafeNameLabel.textColor = UIColor(named: "Brown")
            cafeAddressLabel.textColor = UIColor(named: "BlueColor")
            cafeNameLabel.adjustsFontSizeToFitWidth = true
            cafeAddressLabel.adjustsFontSizeToFitWidth = true
            cafeNameLabel.font = UIFont.boldSystemFont(ofSize: 30)
            cafeAddressLabel.font = UIFont.boldSystemFont(ofSize: 16)
            
            cafeDistance.text = "---"
            cafeDistance.adjustsFontSizeToFitWidth = true
            cafeDistance.textColor = UIColor(named: "NameColor")
            cafeDistance.font = UIFont.boldSystemFont(ofSize: 24)
            [cafeAddressLabel, cafeNameLabel,cafeDistance].forEach {
                contentView.addSubview($0)
            }
            
            cafeNameLabel.snp.makeConstraints { (make) in
                make.leading.equalToSuperview().inset(8)
                make.width.equalTo(UIScreen.main.bounds.width - 140)
                make.top.equalToSuperview().inset(8)
            }
            
            cafeAddressLabel.snp.makeConstraints { (make) in
                make.leading.equalTo(cafeNameLabel)
                make.width.equalTo(UIScreen.main.bounds.width - 80)
                make.top.equalTo(cafeNameLabel.snp.bottom).offset(2)
            }
            
            cafeDistance.snp.makeConstraints { make in
                make.leading.equalTo(cafeNameLabel.snp.trailing).offset(10)
                make.centerY.equalTo(cafeNameLabel.snp.centerY)
                make.width.equalTo(UIScreen.main.bounds.width - 320)
            }
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}
