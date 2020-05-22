//
//  CompassMap.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension Compass:MKMapViewDelegate{
    public func mapSetting(){
        mapView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width*0.5, height: self.frame.size.width*0.5))
        mapView.layer.cornerRadius = mapView.frame.size.height/2
        mapView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        mapView.clipsToBounds = true
        self.addSubview(mapView)
        map = MKMapView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.width))
        map.layer.cornerRadius = map.frame.size.height/2
        map.center = CGPoint(x: mapView.frame.size.width/2, y: mapView.frame.size.height/2)
        map.hero.id = CandidateCellHeroElement.map.rawValue
        map.mapType = .standard
        map.delegate = self
        map.showsUserLocation = true
        //コンパスは表示しない
        map.showsCompass = false
        map.layer.borderWidth = 1
        map.layer.borderColor =  UIColor.lightGray.cgColor
        mapView.addSubview(map)
    }
    ///方角が変わったときにセッティングをする
    public func changeHeading(_ angle:Double,_ nowHeading:Double){
        guard let _ = map else{return}
        map.setUserTrackingMode(.followWithHeading, animated: true)
        transformGoalSymbol(angle,nowHeading)
    }
    ///位置情報が変わったときにセッティングをする
    public func centerSetMap(_ center:CLLocation,_ latitudinalMeters:CLLocationDistance,_ longitudinalMeters:CLLocationDistance){
        guard let _ = map else{return}
        map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: center.coordinate.latitude, longitude: center.coordinate.longitude), latitudinalMeters: latitudinalMeters, longitudinalMeters: longitudinalMeters), animated: true)
    }
    ///ゴール地点にサークルを描く
    public func addingCircleOverLay(_ circle:MKCircle){
        map.addOverlay(circle)
    }
    ///サークルのデザインを決める
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
