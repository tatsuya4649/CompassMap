//
//  SearchHistoryCellMap.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/24.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension SearchHistoryCollectionViewCell:MKMapViewDelegate{
    public func mapSetting(_ region:CLCircularRegion){
        mapView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 0.7*view.bounds.size.height))
        mapView.clipsToBounds = true
        mapView.layer.cornerRadius = view.layer.cornerRadius
        mapView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.contentView.addSubview(mapView)
        map = MKMapView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width + 100, height: 0.7*view.bounds.size.height + 100))
        map.center = CGPoint(x: mapView.frame.size.width/2, y: mapView.frame.size.height/2)
        map.mapType = .standard
        map.showsUserLocation = true
        map.delegate = self
        map.setRegion(MKCoordinateRegion(center: region.center, latitudinalMeters: 10*region.radius, longitudinalMeters: 10*region.radius), animated: false)
        mapView.addSubview(map)
        let circleOverlay = MKCircle(center: region.center, radius: region.radius)
        map.addOverlay(circleOverlay)
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let _ = overlay as? MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = DEFAULT_CIRCLE_STROKECOLOR
            circle.fillColor = DEFAULT_CIRCLE_FILLCOLOR
            circle.lineWidth = DEFAULT_CIRCLE_LINEWIDTH
            return circle
        }
        return MKOverlayRenderer()
    }
}
