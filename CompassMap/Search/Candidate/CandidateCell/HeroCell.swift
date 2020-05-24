//
//  HeroCell.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/21.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Hero

enum CandidateCellHeroElement:String{
    case address = "address"
    case distance = "distance"
    case map = "map"
}

extension CandidateCell{
    ///ヒーロー遷移をするために必要な設定を行うメソッド
    public func addingHero(){
        if addressLabel != nil{
            addressLabel.hero.id = CandidateCellHeroElement.address.rawValue
        }
        if distanceLabel != nil{
            distanceLabel.hero.id = CandidateCellHeroElement.distance.rawValue
        }
        if map != nil{
            map.hero.id = CandidateCellHeroElement.map.rawValue
        }
    }
    ///ヒーロー遷移を解除するために必要な設定を行うメソッド
    public func removeHero(){
        if addressLabel != nil{
            addressLabel.hero.id = nil
        }
        if distanceLabel != nil{
            distanceLabel.hero.id = nil
        }
        if map != nil{
            map.hero.id = nil
        }
    }
}
