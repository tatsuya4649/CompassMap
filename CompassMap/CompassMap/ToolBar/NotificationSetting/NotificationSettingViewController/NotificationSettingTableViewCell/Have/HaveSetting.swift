//
//  HaveSetting.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/25.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

public enum HaveSelection:String{
    case hand = "手に持つ"
    case pocket = "ポケットに入れる"
    
    var number : Int{
        return converted(HaveSelectionInt.self).rawValue
    }
    public init(_ int:Int){
        self.init(HaveSelectionInt(rawValue: int))
    }
    private init<T>(_ t:T){
        self = unsafeBitCast(t, to: HaveSelection.self)
    }
    private func converted<T>(_ t:T.Type)->T{
        return unsafeBitCast(self, to: t)
    }
}
private enum HaveSelectionInt : Int{
    case hand = 0
    case pocket = 1
}

extension NotificationSettingTableViewCell{
    ///持ち方設定欄のセッティングを行うメソッド
    public func haveSetting(_ indexPath:IndexPath,_ width:CGFloat){
        let row = indexPath.row
        switch row {
        case 0:
            haveSegmentControlSetting(width)
        default:break
        }
    }
    
    private func haveSegmentControlSetting(_ width:CGFloat){
        haveSegmentControl = UISegmentedControl(items: [HaveSelection.hand.rawValue,HaveSelection.pocket.rawValue])
        haveSegmentControl.sizeToFit()
        haveSegmentControl.selectedSegmentIndex = 0
        haveSegmentControl.addTarget(self, action: #selector(haveSegmentControlChange), for: .valueChanged)
        haveSegmentControl.center = CGPoint(x: width/2, y: contentView.frame.size.height/2)
        contentView.addSubview(haveSegmentControl)
    }
    
    @objc func haveSegmentControlChange(_ sender:UISegmentedControl){
        print("チェーン時")
        //セグメントコントロールが操作されるたびにUserDefaultsに保存する
        notificationHaveSave(HaveSelection(sender.selectedSegmentIndex))
    }
}
