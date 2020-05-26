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

let MAP_POLYLINE_SIZE : CGFloat = 5.0
let MAP_POLYLINE_COLOR = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.7)

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
        //map.layer.borderWidth = 1
        //map.layer.borderColor =  UIColor.lightGray.cgColor
        mapView.addSubview(map)
        //タイプ別のサイズを定義する
        normalMapSize = self.frame.size.width*0.5
        bigMapSize = self.frame.size.width
    }
    public func nowLocationToGoalLocationPolyLine(){
        guard let delegate = delegate else{return}
        delegate.nowToGoalPolyLine(completion: {[weak self] route in
            guard let _ = self else{return}
            guard let _ = self!.map else{return}
            guard let polyLine = route.polyline as? MKPolyline else{return}
            self!.map.addOverlay(polyLine)
            self!.polyLine = polyLine
        })
    }
    ///位置情報の更新に従って、行う
    public func nowLocationToGoalLocationPolyLineUpdate(_ route:MKRoute){
        guard let _ = map else{return}
        guard let polyline = route.polyline as? MKPolyline else{return}
        removeMapPolyLine()
        map.addOverlay(polyline)
    }
    ///地図上からPolylineを削除するメソッド``
    private func removeMapPolyLine(){
        guard map.overlays.count > 0 else{return}
        for overlay in map.overlays{
            if let polyline = overlay as? MKPolyline{
                map.removeOverlay(overlay)
            }
        }
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
        guard let _ = map else{return}
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
        if let polyLine = overlay as? MKPolyline{
            let routeRenderer = MKPolylineRenderer(polyline:polyLine)
            routeRenderer.lineWidth = MAP_POLYLINE_SIZE
            routeRenderer.strokeColor = MAP_POLYLINE_COLOR
            return routeRenderer
        }
        return MKOverlayRenderer()
    }
    public func changeMapSize(){
        guard let _ = map else{return}
        guard let _ = mapView else{return}
        map.frame = mapView.frame
        map.center = CGPoint(x: mapView.frame.size.width/2, y: mapView.frame.size.height/2)
        map.layer.cornerRadius = map.frame.size.height/2
    }
    public func resetMapSize(){
        guard let _ = map else{return}
        guard let _ = mapView else{return}
        map.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.width)
        map.center = CGPoint(x: mapView.frame.size.width/2, y: mapView.frame.size.height/2)
        map.layer.cornerRadius = map.frame.size.height/2
    }
    ///地図にヒーロー遷移IDを追加するメソッド
    public func addingMapHero(){
        guard let _ = map else{return}
        map.hero.id = CandidateCellHeroElement.map.rawValue
    }
    ///地図のヒーロー遷移IDを削除するメソッド
    public func removeMapHero(){
        guard let _ = map else{return}
        map.hero.id = nil
    }
    
}
