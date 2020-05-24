
//
//  ChangeTheCompas.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/24.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

public enum CompassDesign{
    case normal
    case bigMap
    case arrow
}

extension CompassMapViewController{
    ///コンパスのデザインを変更するときに呼び出されるメソッド
    ///呼び出されるタイミングは、ツールバーのチェンジボタンが押されたとき
    public func changeTheCompass(){
        guard let compassDesign = compassDesign else{return}
        switch compassDesign {
        case .normal:
            print("コンパスのデザインをビッグマップに変更します")
            self.compassDesign = CompassDesign.bigMap
        case .bigMap:
            print("コンパスのデザインをノーマルに変更します")
            self.compassDesign = CompassDesign.arrow
        case .arrow:
            print("コンパスのデザインをアローに変更します")
            self.compassDesign = CompassDesign.normal
        default:break
        }
        //UIデザインを変更するメソッドを呼び出す
        changeTheCompassUI(self.compassDesign)
    }
}
