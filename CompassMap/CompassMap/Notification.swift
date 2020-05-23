//
//  Notification.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/23.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension CompassMapViewController:UNUserNotificationCenterDelegate{
    ///通知のリクエストなど通知に必要な設定を行う
    public func notificationSetting(){
        UNUserNotificationCenter.current().requestAuthorization(
        options: [.alert, .sound, .badge]){
            (granted, _) in
            if granted{
                UNUserNotificationCenter.current().delegate = self
            }
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,willPresent notification: UNNotification,withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        // アプリ起動時も通知を行う
        completionHandler([ .badge, .sound, .alert ])
    }
}
