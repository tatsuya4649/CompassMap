//
//  CompassChangeTheUI.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/24.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension Compass{
    ///コンパスのデザインを変更するメソッド
    public func changeTheCompassUI(_ type:CompassDesign){
        switch type {
        case CompassDesign.normal:compassToNormal()
        case CompassDesign.bigMap:compassToBigMap()
        case CompassDesign.arrow:compassToArrow()
        default:break
        }
    }
    ///コンパスのデザインを通常に変更するメソッド
    private func compassToNormal(){
        changeToNormalUI()
    }
    ///コンパスのデザインをビッグマップに変更するメソッド
    private func compassToBigMap(){
        changeToBigMapUI()
    }
    ///コンパスのデザインをアローに変更するメソッド
    private func compassToArrow(){
        changeToArrowUI()
    }
}
