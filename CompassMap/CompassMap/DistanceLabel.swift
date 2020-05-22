//
//  DistanceLabel.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension CompassMapViewController{
    ///距離を表示させるラベルのセッティングを行う
    public func distanceLabelSetting(){
        guard let goalLocation = goalCenterLocation() else{return}
        guard let userLocation = userLocation else{return}
        distance = Distance(userLocation, goalLocation)
        let distanceString = distance.getTwoLocationDistanceString()
        distanceLabel = UILabel()
        distanceLabel.text = distanceString
        distanceLabel.font = .systemFont(ofSize: DEFAULT_DISTANCE_LABEL_FONT_SIZE, weight: DEFAULT_DISTANCE_LABEL_FONT_WEIGHT)
        distanceLabel.textColor = DEFAULT_DISTANCE_LABEL_FONT_COLOR
        distanceLabel.sizeToFit()
        distanceLabel.center = CGPoint(x: view.center.x, y: addressLabel != nil ? addressLabel.frame.maxY + 10 + distanceLabel.frame.size.height/2 : 10 + distanceLabel.frame.size.height/2)
        view.addSubview(distanceLabel)
    }
}
