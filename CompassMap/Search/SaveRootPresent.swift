//
//  SaveRootPresent.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/26.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

extension SearchViewController{
    public func saveViewControllerGo(){
        guard let saveCompassMapData = UserDefaults.standard.value(forKey: NotificationSettingElement.saveCompassMapData.rawValue) as? Bool else{return}
        //trueのときだけルートに移る
        guard saveCompassMapData else{return}
        //保存してあるデータを取得する
        guard let address = UserDefaults.standard.value(forKey: NotificationSettingElement.address.rawValue) as? String else{return}
        guard let circleRegionLatitude = UserDefaults.standard.value(forKey: NotificationSettingElement.circleRegionLatitude.rawValue) as? Double else{return}
        guard let circleRegionLongitude = UserDefaults.standard.value(forKey: NotificationSettingElement.circleRegionLongitude.rawValue) as? Double else{return}
        guard let circleRegionRadius = UserDefaults.standard.value(forKey: NotificationSettingElement.circleRegionRadius.rawValue) as? Double else{return}
        guard let userLocation = userLocation else{return}
        let dic : Dictionary<SearchElementValue,Any?> = [
            .address : address,
            .region : CLCircularRegion(center: CLLocationCoordinate2D(latitude: circleRegionLatitude, longitude: circleRegionLongitude), radius: circleRegionRadius, identifier: "region"),
        ]
        compassMapViewController = CompassMapViewController()
        compassMapViewController.modalPresentationStyle = .fullScreen
        compassMapViewController.setUp(dic,userLocation)
        present(compassMapViewController, animated: false, completion: {[weak self] in
            guard let _ = self else{return}
            self!.compassMapViewController.resetSizeCompassMap()
            //使用したらUserDefaultsに保存してあるデータは削除する
            UserDefaults.standard.removeObject(forKey: NotificationSettingElement.saveCompassMapData.rawValue)
            UserDefaults.standard.removeObject(forKey: NotificationSettingElement.address.rawValue)
            UserDefaults.standard.removeObject(forKey: NotificationSettingElement.circleRegionRadius.rawValue)
            UserDefaults.standard.removeObject(forKey: NotificationSettingElement.circleRegionLatitude.rawValue)
            UserDefaults.standard.removeObject(forKey: NotificationSettingElement.circleRegionLongitude.rawValue)
        })
    }
}
