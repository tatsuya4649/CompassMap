//
//  LocationManager.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/21.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import CoreLocation

extension CompassMapViewController:CLLocationManagerDelegate{
    ///位置情報を取得するための初期設定メソッド
    public func locationManagerSetting(){
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }

        locationManager.requestWhenInUseAuthorization()
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse {
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            //バックグラウンドでの位置情報の更新を許可する
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.delegate = self
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else{return}
        userLocation = location
        //地図の中心をユーザーに合わせる
        centerSetMap(location)
        //位置情報が更新するたびに距離の更新も行う
        distanceLabelSetting()
        //ルートと時間の更新も行う
        nowToGoalPolyLine(completion: {[weak self] route in
            guard let _ = self else{return}
            self!.settingTimeLabel(route.expectedTravelTime)
            guard let compass = self!.compass else{return}
            compass.nowLocationToGoalLocationPolyLineUpdate(route)
        })
        //読み上げ通知に関するセッティング
        readinHeadingSetting()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //print(newHeading.magneticHeading)
        readingHeadingUpdate(newHeading)
        guard let region = info[.region] as? CLRegion else{return}
        guard let circleRegion = region as? CLCircularRegion else{return}
        guard let _ = userLocation else{return}
        direction = Direction(userLocation, CLLocation(latitude: circleRegion.center.latitude, longitude: circleRegion.center.longitude))
        guard let compass = compass else{return}
        compass.changeHeading(direction.getGoalDirectionFromNow(),Double(newHeading.trueHeading))
    }
}
