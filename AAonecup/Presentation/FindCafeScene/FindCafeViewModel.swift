//
//  FindCafeViewModel.swift
//  AAonecup
//
//  Created by dohankim on 2022/09/20.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay
import CoreLocation
import MapKit


class FindCafeViewModel{
    lazy var nameObservable = PublishSubject<Joke>()
    lazy var cafeListObservable = PublishSubject<[NearCafe]>()
    lazy var isProgressAnimationContinue = PublishSubject<Bool>()
    lazy var distanceObservable = PublishSubject<String>()
    
    lazy var firstJoke = nameObservable.map{
        $0.value
    }
    .map{"\($0 ?? "firstjoke")"}
    lazy var firstJokeurl = nameObservable.map{
        $0.url
    }.map{"\($0 ?? "firstjokeurl")"}
    
    var currentCoord : CLLocationCoordinate2D!
    
    func getCafeList(query : String){
        naverAPI.rxFindNearCafeAPItoNaver(query: query)
            .map{ data -> Cafe in
                let response = try! JSONDecoder().decode(Cafe.self, from: data)
                return response
            }
            .subscribe(onNext: {
                self.getNearCafe(cafe: $0) { nearcafe in
                    self.cafeListObservable.onNext(nearcafe)
                    self.isProgressAnimationContinue.onNext(true)
                }
                
            })
    }
    func getNearCafe(cafe : Cafe,completion : @escaping([NearCafe])->Void){
        var nearCafeArr = [NearCafe]()
        var count = 0
        for i in cafe.items{
            getDistance(ObjectAddress: i.roadAddress.getAvailableAddress()) { distance in
                nearCafeArr.append(NearCafe(cafeName: i.title, cafeAddress: i.roadAddress, distance: distance))
                count+=1
                if count == cafe.items.count{
                    completion(nearCafeArr)
                }
            }
        }
            
        
        
    }
   
    
    func getDistance(ObjectAddress : String, completionDistance : @escaping(String)->Void){
        var currentMapItem = MKMapItem(placemark: MKPlacemark(coordinate: self.currentCoord))
        var distance : String?
        CLGeocoder().geocodeAddressString(ObjectAddress, completionHandler:{(placemarks, error) in
            if error != nil {
                print("에러 발생: \(error!.localizedDescription)")
            } else if placemarks!.count > 0 {
                let placemark = placemarks![0]
                let location = placemark.location
               var objectCoords = location!.coordinate
                //4.showMap을 호출 한다.
                var objectMapItem = MKMapItem(placemark: MKPlacemark(coordinate: objectCoords ))
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
                    completionDistance(distance!)
                    //get the routes, could be multiple routes in the routes[] array but usually [0] is the best route
                }
            }
            
        })
        
        
    }
    

    
    func getDistanceToDestination(srcMapItem srcmapItem: MKMapItem, destMapItem destmapItem: MKMapItem) -> String{
        var distance : CLLocationDistance = 50
        let request = MKDirections.Request() //create a direction request object
        request.source = srcmapItem //this is the source location mapItem object
        request.destination = destmapItem //this is the destination location mapItem object
        request.transportType = MKDirectionsTransportType.automobile //define the transportation method
        
        let directions = MKDirections(request: request) //request directions
        directions.calculate { (response, error) in
            guard let response = response else {
                print("\(error.debugDescription)")
                
                return
            }
            distance = response.routes[0].distance
            //get the routes, could be multiple routes in the routes[] array but usually [0] is the best route
        }
       return "\(distance)"
    }
    
}
