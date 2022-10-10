//
//  Extensions.swift
//  AAonecup
//
//  Created by dohankim on 2022/10/08.
//

import Foundation

extension String{
    func getAvailableAddress() -> String{
        let strArr = self.components(separatedBy: " ")
        var realStrArr = ""
        for i in 0...strArr.count-1{
                realStrArr += " \(strArr[i])"
            if Int(strArr[i]) != nil {
                break
            }
        }
        print("sdddddd\(realStrArr)")
        return realStrArr
        
    }
}
