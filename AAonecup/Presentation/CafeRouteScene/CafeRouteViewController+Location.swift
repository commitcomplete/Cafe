//
//  CafeRouteViewController+Location.swift
//  AAonecup
//
//  Created by dohankim on 2022/11/23.
//

import Foundation
import CoreLocation
import MapKit

extension CafeRouteViewController: CLLocationManagerDelegate {
    func setUpDelegate(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func getRoute(currentCoord: CLLocationCoordinate2D,completion: @escaping (String,MKRoute) -> Void) {
        var currentMapItem = MKMapItem(placemark: MKPlacemark(coordinate: currentCoord))
        var distance : String?
        
        var objectCoords = self.coords
        //4.showMap을 호출 한다.
        var objectMapItem = MKMapItem(placemark: MKPlacemark(coordinate: objectCoords! ))
        let request = MKDirections.Request() //create a direction request object
        request.source = currentMapItem //this is the source location mapItem object
        request.destination = objectMapItem
        request.transportType = MKDirectionsTransportType.walking
        let directions = MKDirections(request: request) //request directions
        directions.calculate { (response, error) in
            guard let response = response else {
                print(error.debugDescription)
                return
            }
            distance = "남은 거리 : \(Int(response.routes[0].distance))M"
            completion(distance!,response.routes[0])
        }
    }
}
