
//
//  CandidateCellAddressLabel.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/21.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

let DEFAULT_DISTANCE_LABEL_FONT_SIZE : CGFloat = 12.0
let DEFAULT_DISTANCE_LABEL_FONT_WEIGHT : UIFont.Weight = .light
let DEFAULT_DISTANCE_LABEL_FONT_COLOR : UIColor = .gray

extension CandidateCell{
    ///住所をもとにラベルを作成するためのメソッド
    public func settingAddressLabel(_ address:String){
        addressLabel = UILabel()
        addressLabel.text = address
        addressLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        addressLabel.textColor = .black
        addressLabel.sizeToFit()
        addressLabel.center = CGPoint(x: contentView.frame.size.width/2, y: 10 + addressLabel.frame.size.height/2)
        contentView.addSubview(addressLabel)
    }
    
    public func settingDistanceLabel(_ region:CLRegion){
        guard let delegate = delegate else{return}
        guard let circleRegion = region as? CLCircularRegion else{return}
        //ユーザーの現在地を取得
        guard let userLocation = delegate.nowUserLocation() else{return}
        let goalLocation = CLLocation(latitude: circleRegion.center.latitude, longitude: circleRegion.center.longitude)
        //2点間の距離を計算する
        let distance = goalLocation.distance(from: userLocation)
        distanceLabel = UILabel()
        distanceLabel.text = stringFromDistance(distance)
        distanceLabel.font = .systemFont(ofSize: DEFAULT_DISTANCE_LABEL_FONT_SIZE, weight: DEFAULT_DISTANCE_LABEL_FONT_WEIGHT)
        distanceLabel.textColor = DEFAULT_DISTANCE_LABEL_FONT_COLOR
        distanceLabel.sizeToFit()
        distanceLabel.center = CGPoint(x: contentView.frame.size.width/2, y: addressLabel.frame.maxY + 5 + distanceLabel.frame.size.height/2)
        contentView.addSubview(distanceLabel)
    }
    
    private func stringFromDistance(_ distance:CLLocationDistance)->String{
        guard distance >= 1000 else{return "\(round(distance*10)/10)m"}
        let km = distance/1000
        return "\(round(km*10)/10)km"
    }
}
