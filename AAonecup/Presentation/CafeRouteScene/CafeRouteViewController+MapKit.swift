//
//  CafeRouteViewController+MapKit.swift
//  AAonecup
//
//  Created by dohankim on 2022/11/23.
//

import Foundation
import MapKit

extension CafeRouteViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let linerenderer = MKPolylineRenderer(overlay: overlay)
        linerenderer.strokeColor = UIColor(named: "AccentColor")
        linerenderer.lineWidth = 3.0
        return linerenderer
    }
    
    func setAnnotation(currentCoord: CLLocationCoordinate2D,
                       objectCoord: CLLocationCoordinate2D,
                       delta span: Double,
                       title strTitle: String,
                       subtitle strSubTitle: String) {
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
