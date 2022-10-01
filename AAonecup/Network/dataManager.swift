//
//  DataManager.swift
//  AAonecup
//
//  Created by dohankim on 2022/09/27.
//

import Foundation
import CoreLocation
class dataManager {
    static let shared : dataManager = dataManager()
    var searchResult : Cafe?
    var currentLocation : CLLocationCoordinate2D
    private init() {
        currentLocation = CLLocationCoordinate2D(latitude: 125, longitude: 37)
    }
}
