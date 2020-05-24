//
//  RegionMapSetting.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/21.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import MapKit

let DEFAULT_LATITUDINALMETERS = 100.0
let DEFAULT_LONGITUDINALMETERS = 100.0
let DEFAULT_CIRCLE_STROKECOLOR = UIColor(red: 0/255, green: 128/255, blue: 255/255, alpha: 0.5)
let DEFAULT_CIRCLE_FILLCOLOR = UIColor(red: 88/255, green: 211/255, blue: 247/255, alpha: 0.4)
let DEFAULT_CIRCLE_LINEWIDTH : CGFloat = 5.0

extension CandidateCell:MKMapViewDelegate{
    ///地図を表示させるためのメソッド
    public func regionMapSetting(_ region:CLRegion){
        print(region)
        guard let circleRegion = region as? CLCircularRegion else{return}
        let circle = MKCircle(center: circleRegion.center, radius: circleRegion.radius)
        map = MKMapView(frame: CGRect(x: 0, y: 0, width: contentView.frame.size.width*0.8, height: contentView.frame.size.width*0.6))
        map.delegate = self
        map.layer.cornerRadius = 20
        map.center = CGPoint(x: contentView.frame.size.width/2, y: addressLabel != nil ? addressLabel.frame.maxY + 5 + map.frame.size.height/2 : 5 + map.frame.size.height/2)
        map.showsUserLocation = true
        contentView.addSubview(map)
        map.addOverlay(circle)
        map.setRegion(MKCoordinateRegion(center: circleRegion.center, latitudinalMeters: circleRegion.radius * 5, longitudinalMeters: circleRegion.radius * 5), animated: false)
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
