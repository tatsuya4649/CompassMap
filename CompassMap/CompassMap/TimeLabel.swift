//
//  TimeLabel.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension CompassMapViewController{
    ///現在地からどれくらいの時間でつくのかを書いたラベルを表示するメソッド
    public func settingTimeLabel(_ time:TimeInterval){
        guard let timeString = timeToString(time) else{return}
        if timeLabel == nil{
            timeLabel = UILabel()
            view.addSubview(timeLabel)
        }
        timeLabel.text = timeString
        timeLabel.font = .systemFont(ofSize: 15, weight: .regular)
        timeLabel.textColor = .gray
        timeLabel.sizeToFit()
        let centerY = distanceLabel != nil ? (distanceLabel.frame.maxY) : (addressLabel.frame.maxY)
        timeLabel.center = CGPoint(x: view.center.x, y: centerY + 10 + timeLabel.frame.size.height/2)
        timeIconLabelSetting()
    }
    
    ///歩きでの時間であることを示すためにウォーキングアイコンを時間の左に添える
    private func timeIconLabelSetting(){
        guard let _ = timeLabel else{return}
        if timeIconLabel == nil{
            timeIconLabel = UILabel()
            view.addSubview(timeIconLabel)
        }
        timeIconLabel.text = String.fontAwesomeIcon(name: .walking)
        timeIconLabel.textColor = .gray
        timeIconLabel.font = UIFont.fontAwesome(ofSize: 15, style: .solid)
        timeIconLabel.sizeToFit()
        timeIconLabel.center = CGPoint(x: timeLabel.frame.minX - 10 - timeIconLabel.frame.size.width/2, y: timeLabel.center.y)
    }
    private func timeToString(_ time:TimeInterval)->String?{
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.day,.minute,.hour,.second]
        let outputString = formatter.string(from: time)
        return outputString
    }
    private func removeTimeLabel(){
        guard let _ = timeLabel else{return}
        timeLabel.removeFromSuperview()
        timeLabel = nil
    }
}
