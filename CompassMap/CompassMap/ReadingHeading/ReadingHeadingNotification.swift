//
//  ReadingHeadingNotification.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/23.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

enum LeftOrRight:String{
    case left = "左"
    case right = "右"
}
extension ReadingHeading{
    ///実際に飛ばす通知を設定していく.
    public func notificationSetting(_ state:ReadingHeadingStateString,_ differenceDirection:Double){
        let content = UNMutableNotificationContent()
        content.title = state.rawValue
        if let body = Direction.makeSentences(false,differenceDirection,state){
            content.body = body
        }
        if let file = stringToFilename(state){
            content.sound = UNNotificationSound(named: UNNotificationSoundName(file.rawValue))
        }
        let request = UNNotificationRequest(identifier: "notification", content: content,trigger: nil)
        //すぐに通知を行う
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
