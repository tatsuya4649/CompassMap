//
//  CompassLabelSetting(){.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

let DEFAULT_MAP_DIRECTIONS_MARGIN : CGFloat = 10.0
extension Compass{
    public func directionLabelSetting(){
        if frontLabel == nil{
            frontLabel = settingLabel("前")
            frontLabel.center = CGPoint(x: mapView.center.x, y: DEFAULT_MAP_DIRECTIONS_MARGIN + frontLabel.frame.size.height/2)
            self.addSubview(frontLabel)
        }
        if backLabel == nil{
            backLabel = settingLabel("後")
            backLabel.center = CGPoint(x: mapView.center.x, y: self.frame.size.height - DEFAULT_MAP_DIRECTIONS_MARGIN - backLabel.frame.size.height/2)
            self.addSubview(backLabel)
        }
        if rightLabel == nil{
            rightLabel = settingLabel("右")
            rightLabel.center = CGPoint(x: self.frame.size.width - DEFAULT_MAP_DIRECTIONS_MARGIN - rightLabel.frame.size.width/2, y: mapView.center.y)
            self.addSubview(rightLabel)
        }
        if leftLabel == nil{
            leftLabel = settingLabel("左")
            leftLabel.center = CGPoint(x: DEFAULT_MAP_DIRECTIONS_MARGIN + leftLabel.frame.size.width/2, y: mapView.center.y)
            self.addSubview(leftLabel)
        }
    }
    ///方向ラベルを全て削除するためのメソッド
    public func removeDirectionLabel(){
        if frontLabel != nil{
            frontLabel.removeFromSuperview()
            frontLabel = nil
        }
        if backLabel != nil{
            backLabel.removeFromSuperview()
            backLabel = nil
        }
        if rightLabel != nil{
            rightLabel.removeFromSuperview()
            rightLabel = nil
        }
        if leftLabel != nil{
            leftLabel.removeFromSuperview()
            leftLabel = nil
        }
    }
    public func settingLabel(_ text:String)->UILabel{
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 17.5, weight: .bold)
        label.textColor = .black
        label.sizeToFit()
        return label
    }
}
