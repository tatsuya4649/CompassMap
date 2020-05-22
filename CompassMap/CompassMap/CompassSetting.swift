//
//  Compass.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension CompassMapViewController:CompassDelegate{
    ///コンパスを表示するために必要なセッティング
    public func compassSetting(){
        compass = Compass(view: view)
        compass.center = view.center
        compass.delegate = self
        view.addSubview(compass)
        view.sendSubviewToBack(compass)
        guard let region = info[.region] as? CLRegion else{return}
        guard let circleRegion = region as? CLCircularRegion else{return}
        let circle = MKCircle(center: circleRegion.center, radius: circleRegion.radius)
        compass.addingCircleOverLay(circle)
    }
    func goalCircle() -> MKCircle? {
        guard let info = info else{return nil}
        guard let region = info[.region] as? CLRegion else{return nil}
        guard let circleRegion = region as? CLCircularRegion else{return nil}
        let circle = MKCircle(center: circleRegion.center, radius: circleRegion.radius)
        return circle
    }
}
