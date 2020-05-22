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
        frontLabel = settingLabel("前")
        backLabel = settingLabel("後")
        rightLabel = settingLabel("右")
        leftLabel = settingLabel("左")
        frontLabel.center = CGPoint(x: mapView.center.x, y: DEFAULT_MAP_DIRECTIONS_MARGIN + frontLabel.frame.size.height/2)
        backLabel.center = CGPoint(x: mapView.center.x, y: self.frame.size.height - DEFAULT_MAP_DIRECTIONS_MARGIN - backLabel.frame.size.height/2)
        rightLabel.center = CGPoint(x: self.frame.size.width - DEFAULT_MAP_DIRECTIONS_MARGIN - rightLabel.frame.size.width/2, y: mapView.center.y)
        leftLabel.center = CGPoint(x: DEFAULT_MAP_DIRECTIONS_MARGIN + leftLabel.frame.size.width/2, y: mapView.center.y)
        self.addSubview(frontLabel)
        self.addSubview(backLabel)
        self.addSubview(rightLabel)
        self.addSubview(leftLabel)
    }
    private func settingLabel(_ text:String)->UILabel{
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 17.5, weight: .bold)
        label.textColor = .black
        label.sizeToFit()
        return label
    }
}
