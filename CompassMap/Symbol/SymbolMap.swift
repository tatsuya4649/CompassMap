//
//  SymbolMap.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import MapKit


class SymbolMap : MKMapView{
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
}

class SymbolMapView : UIView{
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
}

extension Symbol:MKMapViewDelegate{
    public func settingSymbolMap(){
        mapView = SymbolMapView(frame: button.frame)
        mapView.layer.cornerRadius = mapView.frame.size.height/2
        mapView.clipsToBounds = true
        button.addSubview(mapView)
        map = SymbolMap(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        map.layer.cornerRadius = map.frame.size.height/2
        map.showsUserLocation = true
        map.delegate = self
        map.center = CGPoint(x: mapView.frame.size.width/2, y: mapView.frame.size.height/2)
        mapView.addSubview(map)
        guard let delegate = delegate else{return}
        guard let circle = delegate.goalCircle() else{return}
        map.addOverlay(circle)
        map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: circle.coordinate.latitude, longitude: circle.coordinate.longitude), latitudinalMeters: circle.radius * 30, longitudinalMeters: circle.radius * 30), animated: false)
    }
    ///地図からフラッグに変更するときに地図を削除するメソッド
    public func removeMap(){
        guard let _ = mapView else{return}
        mapView.removeFromSuperview()
        mapView = nil
        guard let _ = map else{return}
        map.removeFromSuperview()
        map = nil
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
