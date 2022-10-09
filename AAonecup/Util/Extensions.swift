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
        var realStrArr = ""
        for i in 0...strArr.count{
                realStrArr += " \(strArr[i])"
            if Int(strArr[i]) != nil {
                break
            }
        }
        
        return realStrArr
        
    }
}
