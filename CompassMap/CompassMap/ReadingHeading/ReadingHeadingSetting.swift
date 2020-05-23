//
//  ReadingHeadingSetting.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/23.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import CoreLocation

extension CompassMapViewController{
    ///位置情報が更新されるたびに呼ばれるメソッド
    ///必要であれば読み上げ通知を行い、ReadingHeadingの更新を行う
    public func readinHeadingSetting(){
        guard let region = info[.region] as? CLRegion else{return}
        guard let circleRegion = region as? CLCircularRegion else{return}
        guard let _ = userLocation else{return}
        if readingHeading == nil{
            //初期化__ゴール地点の座標を登録する
            readingHeading = ReadingHeading(CLLocation(latitude: circleRegion.center.latitude, longitude: circleRegion.center.longitude))
        }
        //ReadingHeading側に更新されたことを知らせてあげる
        readingHeading.updateUserLocation(userLocation)
    }
    ///ユーザーの向いている方角を更新されたら呼ばれるメソッド
    public func readingHeadingUpdate(_ userHeading:CLHeading){
        guard let _ = readingHeading else{return}
        //読み上げ通知クラスにも更新された方角を知らせてあげる
        readingHeading.updateUserHeading(userHeading)
    }
}
