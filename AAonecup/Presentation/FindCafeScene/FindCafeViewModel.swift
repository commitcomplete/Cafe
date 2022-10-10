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
    lazy var isProgressOutOfTime = PublishSubject<Bool>()
    lazy var distanceObservable = PublishSubject<String>()
    var progressCountTimer: Timer? = nil
    lazy var firstJoke = nameObservable.map{
        $0.value
    }
    .map{"\($0 ?? "firstjoke")"}
    lazy var firstJokeurl = nameObservable.map{
        $0.url
    }.map{"\($0 ?? "firstjokeurl")"}
    
    var currentCoord : CLLocationCoordinate2D!
    
    func getCafeList(query : String){
        progressCountTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            self.isProgressOutOfTime.onNext(true)
        }
        
        naverAPI.rxFindNearCafeAPItoNaver(query: query)
            .map{ data -> Cafe in
                let response = try! JSONDecoder().decode(Cafe.self, from: data)
                return response
            }
            .subscribe(onNext: {
                self.getNearCafe(cafe: $0) { nearcafe in
                    self.cafeListObservable.onNext(nearcafe)
                    self.isProgressAnimationContinue.onNext(true)
                    self.progressCountTimer?.invalidate()
                }
                
            })
    }
    func getNearCafe(cafe : Cafe,completion : @escaping([NearCafe])->Void){
        var nearCafeArr = [NearCafe]()
        var count = 0
        for i in cafe.items{
            getDistance(ObjectAddress: i.roadAddress.getAvailableAddress()) { distance,route,objectcoords in
                nearCafeArr.append(NearCafe(cafeName: i.title, cafeAddress: i.roadAddress, distance: distance,route: route,coords: objectcoords))
                count+=1
                if count == cafe.items.count{
                    completion(nearCafeArr)
                }
            }
        }
            
        
        
    }
   
    
    func getDistance(ObjectAddress : String, completionDistance : @escaping(String,MKRoute,CLLocationCoordinate2D)->Void){
        var currentMapItem = MKMapItem(placemark: MKPlacemark(coordinate: self.currentCoord))
        var distance : String?
        print(ObjectAddress)
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
                    completionDistance(distance!,response.routes[0],objectCoords)
                    //get the routes, could be multiple routes in the routes[] array but usually [0] is the best route
                }
            }
            
        })
        
        
    }
    

    
    
}
