//
//  SearchHistoryDistance.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/24.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

extension SearchHistoryCollectionViewCell{
    ///ユーザーの距離と目的地の距離を記載するラベルをセッティングするメソッド
    public func distanceSetting(_ region:CLCircularRegion){
        guard let userLocation = userLocation else{return}
        distance = Distance(userLocation, CLLocation(latitude: region.center.latitude, longitude: region.center.longitude))
        settingDistanceLabel()
        distanceLabel.text = distance.getTwoLocationDistanceString()
        distanceLabel.font = .systemFont(ofSize: 12, weight: .light)
        distanceLabel.textColor = .black
        distanceLabel.sizeToFit()
        distanceLabel.center = CGPoint(x: 5 + distanceLabel.frame.size.width/2, y: 5 + distanceLabel.frame.size.height/2)
        mapView.bringSubviewToFront(distanceLabel)
    }
    ///検索画面でユーザー位置情報の更新があったときに呼び出されるメソッド
    ///ユーザー座標とゴール座標からの距離を算出して距離ラベルを更新する
    public func updateDistanceLabel(_ userLocation:CLLocation){
        guard let info = info else{return}
        guard let region = info[.region] as? CLCircularRegion else{return}
        distance = Distance(userLocation, CLLocation(latitude: region.center.latitude, longitude: region.center.longitude))
        settingDistanceLabel()
        distanceLabel.text = distance.getTwoLocationDistanceString()
        distanceLabel.font = .systemFont(ofSize: 12, weight: .light)
        distanceLabel.textColor = .black
        distanceLabel.sizeToFit()
        distanceLabel.center = CGPoint(x: 5 + distanceLabel.frame.size.width/2, y: 5 + distanceLabel.frame.size.height/2)
        mapView.bringSubviewToFront(distanceLabel)
    }
    private func settingDistanceLabel(){
        if distanceLabel == nil{
            distanceLabel = UILabel()
            mapView.addSubview(distanceLabel)
        }
    }
}
