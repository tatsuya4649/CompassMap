//
//  BaseSetting.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/25.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension NotificationSettingTableViewCell{
    ///基本設定欄のセッティングを行うメソッド
    public func settingBase(_ indexPath:IndexPath,_ width:CGFloat){
        let row = indexPath.row
        switch row {
        case 0:
            titleLabelSetting("通知")
            notificationSwitchSetting(width)
        default:break
        }
    }
    ///スイッチを作成するメソッド
    private func notificationSwitchSetting(_ width:CGFloat){
        notificationSwitch = UISwitch()
        notificationSwitch.sizeToFit()
        if let bool = UserDefaults.standard.value(forKey: NotificationSettingElement.notificationOnOrOff.rawValue) as? Bool{
            notificationSwitch.isOn = bool
        }else{
            notificationSwitch.isOn = NOTIFICATION_BOOL_DEFAULT_VALUE
        }
        notificationSwitch.center = CGPoint(x: width - 20 - notificationSwitch.frame.size.width/2, y: contentView.frame.size.height/2)
        notificationSwitch.addTarget(self, action: #selector(notificationSwitchChange), for: .valueChanged)
        contentView.addSubview(notificationSwitch)
        print(notificationSwitch.frame)
    }
    ///スイッチが切り替わったときに呼ばれるメソッド
    @objc func notificationSwitchChange(_ sender:UISwitch){
        print("通知が\(sender.isOn ? "オン" : "オフ")に切り替わりました")
        //スイッチが切り替わるたびにUserDefaultsに保存する
        notificationOnOrOffSave(sender.isOn)
    }
}
