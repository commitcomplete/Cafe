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
import CoreLocation

class CafeRouteViewController : UIViewController{
    var myCoordinates : CLLocationCoordinate2D? = nil
    var myPlacemark :MKPlacemark? = nil
    var myMapItem : MKMapItem? = nil
    var route: MKRoute!
    var coords : CLLocationCoordinate2D!
    var placeString1 : String = ""
    var placeString2 : String = ""
    var currentDistance : Int = 0
    let locationManager = CLLocationManager()
    
    private lazy var startbutton : UIButton = {
        let button = UIButton()
        button.setTitle("dfsdfs", for: .normal)
        button.backgroundColor = .red
        return button
    }()
    
    private lazy var distanceLabel : UILabel = {
        let label = UILabel()
        label.text = "1234"
        label.textColor = UIColor(named: "AccentColor")
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    private lazy var myMap : MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(myMap)
        view.addSubview(distanceLabel)
        distanceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
        }
        myMap.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        myMap.delegate = self
        self.myMap.addOverlay(self.route.polyline,level: .aboveRoads)
        self.myMap.showsUserLocation = true
        self.myMap.setUserTrackingMode(.follow, animated: true)
        self.setAnnotation(currentCoord: myCoordinates!, objectCoord: coords, delta: 0.1,title: placeString1, subtitle: placeString2)
        setUpDelegate()
//        myMap.insertOverlay(route.polyline, at: 0)
//        myMap.region = MKCoordinateRegion(center: myCoordinates!, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
        self.distanceLabel.text = "남은거리 : \(currentDistance)M"
    }
    
    
}

extension CafeRouteViewController : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let linerenderer = MKPolylineRenderer(overlay: self.route.polyline)
        linerenderer.strokeColor = UIColor(named: "AccentColor")
        linerenderer.lineWidth = 3.0
        return linerenderer
    }
    
    
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print("updata!!")
//        getRoute(currentCoord: userLocation.coordinate) { distance, route in
//            if self.currentDistance != Int(route.distance){
//                mapView.addOverlay(route.polyline)
//                self.distanceLabel.text = "남은거리 : \(distance)"
//                self.currentDistance = Int(route.distance)
//            }
//        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func setAnnotation(currentCoord : CLLocationCoordinate2D,
                       objectCoord : CLLocationCoordinate2D,
                       delta span :Double,
                       title strTitle: String,
                       subtitle strSubTitle:String){
        let annotation = MKPointAnnotation()
        annotation.coordinate = objectCoord
        annotation.title = strTitle.replacingOccurrences(of: "<b>", with:" ")
            .replacingOccurrences(of: "</b>", with:" ")
        annotation.subtitle = strSubTitle
        
        let currentAnnotation = MKPointAnnotation()
        currentAnnotation.coordinate  = currentCoord
        currentAnnotation.title = "출발"
        myMap.showAnnotations([annotation,currentAnnotation], animated: true)
    }
    
}

extension CafeRouteViewController : CLLocationManagerDelegate{
    func setUpDelegate(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func getRoute(currentCoord : CLLocationCoordinate2D,completion: @escaping (String,MKRoute) -> Void){
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
            distance = "\(Int(response.routes[0].distance))M"
            completion(distance!,response.routes[0])
            //get the routes, could be multiple routes in the routes[] array but usually [0] is the best route
        }
        
        
        
    }
    
    
}


