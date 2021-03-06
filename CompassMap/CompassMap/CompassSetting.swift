//
//  Compass.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension CompassMapViewController:CompassDelegate{
    ///コンパスを表示するために必要なセッティング
    public func compassSetting(){
        compass = Compass(view: view)
        compass.center = view.center
        compass.delegate = self
        compass.nowLocationToGoalLocationPolyLine()
        compass.changeMapSize()
        view.addSubview(compass)
        view.sendSubviewToBack(compass)
        compassDesign = CompassDesign.normal
        guard let region = info[.region] as? CLRegion else{return}
        guard let circleRegion = region as? CLCircularRegion else{return}
        let circle = MKCircle(center: circleRegion.center, radius: circleRegion.radius)
        compass.addingCircleOverLay(circle)
    }
    func goalCircle() -> MKCircle? {
        guard let info = info else{return nil}
        guard let region = info[.region] as? CLRegion else{return nil}
        guard let circleRegion = region as? CLCircularRegion else{return nil}
        let circle = MKCircle(center: circleRegion.center, radius: circleRegion.radius)
        return circle
    }
    func nowUserRegion() -> MKCoordinateRegion? {
        guard let userLocation = userLocation else{return nil}
        if latitudinalMeters == nil{
            if  let info = info{
                if let region = info[.region] as? CLRegion{
                    if let circleRegion = region as? CLCircularRegion{
                        latitudinalMeters = 5*circleRegion.radius
                    }
                }
            }
        }
        if longitudinalMeters == nil{
            if  let info = info{
                if let region = info[.region] as? CLRegion{
                    if let circleRegion = region as? CLCircularRegion{
                        longitudinalMeters = 5*circleRegion.radius
                    }
                }
            }
        }
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), latitudinalMeters: latitudinalMeters != nil ? latitudinalMeters : 100, longitudinalMeters: longitudinalMeters != nil ? longitudinalMeters : 100)
    }
    //現在地と目的地から歩きのルートを検索してPolyLineのみを返すデリゲートメソッド
    func nowToGoalPolyLine(completion:((MKRoute)->Void)?) {
        guard let region = info[.region] as? CLRegion else{return}
        guard let circleRegion = region as? CLCircularRegion else{return}
        guard let _ = userLocation else{return}
        let fromPlacemark = MKPlacemark(coordinate:CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), addressDictionary:nil)
        let toPlacemark = MKPlacemark(coordinate:circleRegion.center, addressDictionary:nil)
        let fromMapItem = MKMapItem(placemark: fromPlacemark)
        let toMapItem = MKMapItem(placemark: toPlacemark)
        let request = MKDirections.Request()
        request.source = fromMapItem
        request.destination = toMapItem
        request.requestsAlternateRoutes = false
        request.transportType = MKDirectionsTransportType.walking
        let directions = MKDirections(request:request)
        directions.calculate(completionHandler: { [weak self] (result,error) in
            guard let _ = self else{return}
            guard error == nil else{return}
            guard let result = result else{return}
            guard let routes = result.routes as? Array<MKRoute> else{return}
            guard let route = routes.first else{return}
            self!.settingTimeLabel(route.expectedTravelTime)
            completion?(route)
        })
    }
    public func resetSizeCompassMap(){
        guard let _ = compass else{return}
        compass.resetMapSize()
    }
    ///コンパスのデザインを変更する際に呼び出されるメソッド
    public func changeTheCompassUI(_ type:CompassDesign){
        guard let compass = compass else{return}
        compass.changeTheCompassUI(type)
    }
}
