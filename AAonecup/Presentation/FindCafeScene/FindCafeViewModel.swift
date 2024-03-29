//
//  FindCafeViewModel.swift
//  AAonecup
//
//  Created by dohankim on 2022/09/20.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation
import MapKit


class FindCafeViewModel {
    
    lazy var cafeListObservable = PublishSubject<[CafeInfo]>()
    lazy var isProgressAnimationContinue = PublishSubject<Bool>()
    lazy var isProgressOutOfTime = PublishSubject<Bool>()
    lazy var isSearchLimitTimeIsOver = PublishSubject<Int>()
    lazy var distanceObservable = PublishSubject<String>()
    var progressCountTimer: Timer? = nil
    var searchLimitTimer: Timer? = nil
    
    var currentCoord: CLLocationCoordinate2D!
    
    func getDistance(ObjectAddress: String, completionDistance: @escaping(String,MKRoute,CLLocationCoordinate2D)->Void){
        let currentMapItem = MKMapItem(placemark: MKPlacemark(coordinate: self.currentCoord))
        var distance: String?
        CLGeocoder().geocodeAddressString(ObjectAddress, completionHandler:{(placemarks, error) in
            if error != nil {
                print("에러 발생: \(error!.localizedDescription)")
            } else if placemarks!.count > 0 {
                let placemark = placemarks![0]
                let location = placemark.location
                let objectCoords = location!.coordinate
                //4.showMap을 호출 한다.
                let objectMapItem = MKMapItem(placemark: MKPlacemark(coordinate: objectCoords ))
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
                    distance = "\(Int(response.routes[0].distance))M"
                    completionDistance(distance!,response.routes[0],objectCoords)
                }
            }
        })
    }
    
    func getNearCafeList(currentCoord: CLLocationCoordinate2D){
        progressCountTimer = Timer.scheduledTimer(withTimeInterval:6.0, repeats: false) { _ in
            self.isProgressOutOfTime.onNext(true)
        }
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "cafe"
        searchRequest.region = MKCoordinateRegion(center: currentCoord, span: MKCoordinateSpan(latitudeDelta: 0.01  , longitudeDelta: 0.01))
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let response = response else {
                // Handle the error.
                return
            }
            var nearCafeList = [CafeInfo]()
            var count = 0
            for item in response.mapItems {
                count+=1
                if let name = item.placemark.name,
                   let location = item.placemark.location {
                    self.getNearCafeDistance(objectCoord: location.coordinate) { distance, route, coord in
                        nearCafeList.append(CafeInfo(cafeName: name, cafeAddress: item.placemark.title ?? "지구", distance: distance, route: route, coords: coord))
                        if count == nearCafeList.count{
                            self.cafeListObservable.onNext(nearCafeList.sorted(by: {$0.distance < $1.distance}))
                            self.isProgressAnimationContinue.onNext(true)
                            self.progressCountTimer?.invalidate()
                        }
                    }
                }
            }
        }
    }
    
    
    func getNearCafeDistance(objectCoord: CLLocationCoordinate2D, completionDistance: @escaping(Int,MKRoute,CLLocationCoordinate2D)->Void){
        let currentMapItem = MKMapItem(placemark: MKPlacemark(coordinate: self.currentCoord))
        var distance: Int?
        let objectMapItem = MKMapItem(placemark: MKPlacemark(coordinate: objectCoord ))
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
            distance = Int(response.routes[0].distance)
            completionDistance(distance!,response.routes[0],objectCoord)
            
        }
        
    }
    func limitSearchTime(inputSeconds: Int) {
        var seconds = inputSeconds
        DispatchQueue.global(qos: .background).async {
            self.isSearchLimitTimeIsOver.onNext(seconds)
            self.searchLimitTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
                seconds = seconds - 1
                self.isSearchLimitTimeIsOver.onNext(seconds)
                if seconds == 0 {
                    timer.invalidate()
                }
            })
            RunLoop.current.run()
        }
    }
    
}
