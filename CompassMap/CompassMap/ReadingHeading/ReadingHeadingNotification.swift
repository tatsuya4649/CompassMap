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
        content.title = notificationTitlePocketOrHand(state)
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
    private func notificationTitlePocketOrHand(_ state:ReadingHeadingStateString)->String{
        var have : HaveSelection = NOTIFICATION_HAVE_DEFAULT_VALUE
        print(UserDefaults.standard.value(forKey: NotificationSettingElement.have.rawValue) as? String)
        if let notificationHave = UserDefaults.standard.value(forKey: NotificationSettingElement.have.rawValue) as? String{
            if let haveCheck = HaveSelection(rawValue: notificationHave){
                have = haveCheck
            }
        }
        switch have {
        case .hand:return state.rawValue
        case .pocket:return ReadingHeadingStatePocketString(string: state.rawValue).rawValue
        default:return ""
        }
        print(have.rawValue)
    }
}
