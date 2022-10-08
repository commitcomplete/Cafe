//
//  CafeRouteViewController.swift
//  AAonecup
//
//  Created by dohankim on 2022/10/07.
//

import Foundation
import UIKit
import RxSwift
import MapKit
import SnapKit

class CafeRouteViewController : UIViewController{
    var myCoordinates : CLLocationCoordinate2D? = nil
    var myPlacemark :MKPlacemark? = nil
    var myMapItem : MKMapItem? = nil
    var route: MKRoute!
    var placeString1 : String = ""
    var placeString2 : String = ""
    private lazy var startbutton : UIButton = {
        let button = UIButton()
        button.setTitle("dfsdfs", for: .normal)
        button.backgroundColor = .red
        return button
    }()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCoordinates =  CLLocationCoordinate2D(latitude: 25.647399800, longitude: -100.334304500)
        myPlacemark = MKPlacemark(coordinate: myCoordinates ?? CLLocationCoordinate2D(latitude: 25.647399800, longitude: -100.334304500))
        var myMapItem1 = MKMapItem(placemark: myPlacemark ?? MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 25.647399800, longitude: -100.334304500)))
        var myMapItem2 = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 36.015570100000716, longitude: 129.31431215393974)))
        var myMapItem3 = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 36.012510710107776, longitude: 129.33578035375245)))
        view.addSubview(startbutton)
        view.backgroundColor = .blue
        startbutton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        getDistanceToDestination(srcMapItem: myMapItem2, destMapItem: myMapItem3)
    }
    
    func getDistanceToDestination(srcMapItem srcmapItem: MKMapItem, destMapItem destmapItem: MKMapItem){
        let request = MKDirections.Request() //create a direction request object
        request.source = srcmapItem //this is the source location mapItem object
        request.destination = destmapItem //this is the destination location mapItem object
        request.transportType = MKDirectionsTransportType.automobile //define the transportation method
        
        let directions = MKDirections(request: request) //request directions
        directions.calculate { (response, error) in
            guard let response = response else {
                print(error.debugDescription)
                return
            }
            self.route = response.routes[0]
            //get the routes, could be multiple routes in the routes[] array but usually [0] is the best route
        }
    }
}

