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

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.backgroundColor = .clear
            cafeNameLabel.textColor = UIColor(named: "NameColor")
            cafeAddressLabel.textColor = UIColor(named: "Brown")
            [cafeAddressLabel, cafeNameLabel].forEach {
                contentView.addSubview($0)
            }
            
            cafeNameLabel.snp.makeConstraints { (make) in
                make.leading.equalToSuperview().inset(8)
                make.top.equalToSuperview().inset(8)
            }
            
            cafeAddressLabel.snp.makeConstraints { (make) in
                make.leading.equalTo(cafeNameLabel)
                make.top.equalTo(cafeNameLabel.snp.bottom).offset(2)
            }
            
            cafeNameLabel.font = UIFont.boldSystemFont(ofSize: 30)
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}
