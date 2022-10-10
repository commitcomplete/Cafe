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
        return realStrArr
        
    }
    
}

extension Double {
  var prettyDistance: String {
    guard self > -.infinity else { return "?" }
    let formatter = LengthFormatter()
    formatter.numberFormatter.maximumFractionDigits = 2
    if self >= 1000 {
      return formatter.string(fromValue: self / 1000, unit: LengthFormatter.Unit.kilometer)
    } else {
      let value = Double(Int(self)) // 미터로 표시할 땐 소수점 제거
      return formatter.string(fromValue: value, unit: LengthFormatter.Unit.meter)
    }
  }
}
