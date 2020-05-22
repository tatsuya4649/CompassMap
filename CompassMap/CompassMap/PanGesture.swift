//
//  PanGesture.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/21.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import Hero

extension CompassMapViewController{
    ///画面のパンに反応するように初期設定を行うメソッド
    public func panGestureSetting(){
        pan = UIPanGestureRecognizer(target: self, action: #selector(panNow))
        view.addGestureRecognizer(pan)
    }
    @objc func panNow(_ sender:UIPanGestureRecognizer){
        let transition = sender.translation(in: nil)
        let progress = transition.y/2 / view.bounds.height
        switch sender.state {
        case .began:
            if compass != nil{
                compass.changeMapSize()
            }
            hero_dismissViewController()
        case .changed:
            let translation = sender.translation(in: nil)
            let progress = transition.y/2 / view.bounds.height
            Hero.shared.update(progress)
        case .ended:
            if progress + sender.velocity(in: nil).y / view.bounds.height > 0.3 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
            if compass != nil{
                compass.resetMapSize()
            }
        default:break
        }
    }
}
