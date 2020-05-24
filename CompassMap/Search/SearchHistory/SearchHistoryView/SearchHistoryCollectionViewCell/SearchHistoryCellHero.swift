//
//  SearchHistoryCellHero.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/24.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import Hero
import UIKit

extension SearchHistoryCollectionViewCell{
    ///ヒーロー遷移をするときに必要なIDを追加する
    public func addingHero(){
        if map != nil{
            map.hero.id = CandidateCellHeroElement.map.rawValue
        }
        if addressLabel != nil{
            addressLabel.hero.id = CandidateCellHeroElement.address.rawValue
        }
    }
}
