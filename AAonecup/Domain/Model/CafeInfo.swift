//
//  CafeInfo.swift
//  AAonecup
//
//  Created by dohankim on 2022/10/10.
//


import Foundation
import MapKit

struct CafeInfo {
    var cafeName: String
    var cafeAddress: String
    var distance: Int
    var route: MKRoute
    var coords: CLLocationCoordinate2D
}
