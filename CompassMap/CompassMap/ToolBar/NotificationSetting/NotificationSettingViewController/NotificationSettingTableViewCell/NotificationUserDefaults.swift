//
//  NotificationUserDefaults.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/25.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

public enum NotificationSettingElement:String{
    ///UserDefaultsでブール型として保存
    case notificationOnOrOff = "notificationOnOrOff"
    ///UserDefaultsで整数型として保存
    case distance = "distance"
    case have = "have"
    case saveCompassMapData = "saveCompassMapData"
    case address = "address"
    case circleRegionLatitude = "circleRegionLatitude"
    case circleRegionLongitude = "circleRegionLongitude"
    case circleRegionRadius = "circleRegionRadius"
}
let NOTIFICATION_DISTANCE_DEFAULT_VALUE : Double = 500.0
let NOTIFICATION_BOOL_DEFAULT_VALUE : Bool = false
let NOTIFICATION_HAVE_DEFAULT_VALUE : HaveSelection = HaveSelection.hand
extension NotificationSettingTableViewCell{
    ///通知のオン・オフをUserDefaultsに保存する
    public func notificationOnOrOffSave(_ bool:Bool){
        UserDefaults.standard.setValue(bool, forKey: NotificationSettingElement.notificationOnOrOff.rawValue)
    }
    ///通知距離設定の値をUserDefaultsに保存する
    public func notificationDistanceSave(_ distance:Int){
        UserDefaults.standard.setValue(distance, forKey: NotificationSettingElement.distance.rawValue)
    }
    ///持ち方設定の値をUserDefaultsに保存する
    public func notificationHaveSave(_ have:HaveSelection){
        UserDefaults.standard.setValue(have.rawValue, forKey: NotificationSettingElement.have.rawValue)
    }
}
