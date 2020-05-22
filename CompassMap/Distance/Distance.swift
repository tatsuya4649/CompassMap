//
//  Distance.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import MapKit

final class Distance{
    var location1 : CLLocation!
    var location2 : CLLocation!
    init(_ location1:CLLocation,_ location2:CLLocation) {
        self.location1 = location1
        self.location2 = location2
    }
    public func getTwoLocationDistanceString() -> String{
        return distanceToString(getTwoLocationDistance())
    }
    ///クラスメソッド
    public class func getTwoLocationDistanceString(_ location1:CLLocation,_ location2:CLLocation) -> String{
        let distance = location2.distance(from: location1)
        if distance < 1000{
            return "\(round(distance*10)/10)m"
        }else{
            let km = distance/1000
            return "\(round(km*10)/10)km"
        }
    }
    public func getTwoLocationDistance() -> Double{
        let distance = location2.distance(from: location1)
        return Double(distance)
    }
    private func distanceToString(_ distance:Double) -> String{
        if distance < 1000{
            return "\(round(distance*10)/10)m"
        }else{
            let km = distance/1000
            return "\(round(km*10)/10)km"
        }
    }
}
