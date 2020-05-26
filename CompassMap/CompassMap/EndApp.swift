//
//  EndApp.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/25.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension CompassMapViewController{
    ///アプリが閉じる瞬間に呼ばれるメソッド
    @objc func endApp(){
        print("呼ばれていないの？")
        //UserDefaults.standard.setValue(true, forKey: NotificationSettingElement.saveCompassMapData.rawValue)
    }
}
