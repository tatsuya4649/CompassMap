//
//  Direction.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

final class Direction{
    
    var nowLocation : CLLocation!
    var goalLocation : CLLocation!
    
    init(_ nowLocation:CLLocation,_ goalLocation:CLLocation) {
        self.nowLocation = nowLocation
        self.goalLocation = goalLocation
    }
    
    ///今いる場所から見たゴール地点の方角を計算する
    public func getGoalDirectionFromNow() -> Double{
        let nowLocationLatitude = toRadian(nowLocation.coordinate.latitude)
        let nowLocationLongitude = toRadian(nowLocation.coordinate.longitude)
        let goalLocationLatitude = toRadian(goalLocation.coordinate.latitude)
        let goadLocationLongitude = toRadian(goalLocation.coordinate.longitude)
        
        let difLongitude = goadLocationLongitude - nowLocationLongitude
        let y = sin(difLongitude)
        let x = cos(nowLocationLatitude) * tan(goalLocationLatitude) - sin(nowLocationLatitude) * cos(difLongitude)
        let p = atan2(y, x) * 180 / Double.pi
        
        if p < 0 {
            return Double(360 + atan2(y, x) * 180 / Double.pi)
        }
        return Double(atan2(y, x) * 180 / Double.pi)
    }
    
    private func toRadian(_ angle:Double) -> Double{
        return angle * Double.pi / 180
    }
    
    public class func makeSentences(_ addStateRawValue:Bool,_ differenceDirection:Double,_ state:ReadingHeadingStateString)->String?{
        guard differenceDirection != 0.0 && differenceDirection != 360.0 else{return nil}
        var leftOrRight = String()
        //180度以下なら左回り
        if differenceDirection <= 180{
            leftOrRight = LeftOrRight.right.rawValue
        }else{
            //180度以上なら右回り
            leftOrRight = LeftOrRight.left.rawValue
        }
        let string = "\(leftOrRight)に\(round(differenceDirection))度回転した方向が正しい方向です。"
        return addStateRawValue ? state.rawValue + string : string
    }
}
