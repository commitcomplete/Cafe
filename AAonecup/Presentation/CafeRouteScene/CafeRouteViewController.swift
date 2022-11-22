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
    var refreshTimer : Timer? = nil
    var routeOverLay : MKOverlay? = nil
    
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
    
    lazy var myMap : MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(myMap)
        view.addSubview(distanceLabel)
        setUpLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        setUpRefreshTimer()
    }
    override func viewWillDisappear(_ animated: Bool) {
        refreshTimer?.invalidate()
    }
}

extension CafeRouteViewController {
    func setUpRefreshTimer(){
        routeOverLay = route.polyline
        self.myMap.addOverlay(routeOverLay!)
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: { _ in
            self.getRoute(currentCoord: self.locationManager.location!.coordinate) { distance, newRoute in
                self.distanceLabel.text = distance
                self.myMap.removeOverlay(self.routeOverLay!)
                self.routeOverLay = newRoute.polyline
                self.myMap.addOverlay(self.routeOverLay!)
                
            }
        })
    }
    
    func setUpLayout(){
        distanceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        myMap.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        myMap.delegate = self
        self.myMap.showsUserLocation = true
        self.myMap.setUserTrackingMode(.follow, animated: true)
        self.setAnnotation(currentCoord: myCoordinates!, objectCoord: coords, delta: 0.1,title: placeString1, subtitle: placeString2)
        setUpDelegate()
        self.distanceLabel.text = "남은 거리 : \(currentDistance)M"
    }
}
