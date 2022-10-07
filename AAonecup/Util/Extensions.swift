//
//  Extensions.swift
//  AAonecup
//
//  Created by dohankim on 2022/10/08.
//

import Foundation

extension String{
    func getAvailableAddress() -> String{
        var strArr = self.components(separatedBy: " ")
        return strArr[0]+strArr[1]+strArr[2]+strArr[3]+strArr[4]
    }
}
