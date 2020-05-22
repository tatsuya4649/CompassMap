//
//  CompassGoal.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import MapKit

let DEFAULT_GOAL_SYMBOL_WIDTH_HEIGHT_SIZE : CGFloat = 50.0
let DEFAULT_GOAL_SYMBOL_MARGIN : CGFloat = 2.0
extension Compass:SymbolDelegate{
    func goalCircle() -> MKCircle? {
        guard let delegate = delegate else{return nil}
        return delegate.goalCircle()
    }
    
    ///コンパスのゴールをボタンで表示させる
    public func goalSymbolSetting(){
        goalSymbolBaseView = UIView(frame: CGRect(x: 0, y: 0, width: mapView.frame.size.width + 2*(DEFAULT_GOAL_SYMBOL_MARGIN + DEFAULT_GOAL_SYMBOL_WIDTH_HEIGHT_SIZE), height: mapView.frame.size.height + 2*(DEFAULT_GOAL_SYMBOL_MARGIN + DEFAULT_GOAL_SYMBOL_WIDTH_HEIGHT_SIZE)))
        goalSymbolBaseView.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        goalSymbolBaseView.center = mapView.center
        goalSymbolBaseView.layer.cornerRadius = goalSymbolBaseView.frame.size.height/2
        self.addSubview(goalSymbolBaseView)
        goalSymbol = Symbol(frame: CGRect(x: 0, y: 0, width: DEFAULT_GOAL_SYMBOL_WIDTH_HEIGHT_SIZE, height: DEFAULT_GOAL_SYMBOL_WIDTH_HEIGHT_SIZE))
        goalSymbol.backgroundColor = .black
        goalSymbol.center = CGPoint(x: goalSymbolBaseView.frame.size.width/2, y: goalSymbol.frame.size.height/2)
        goalSymbol.layer.cornerRadius = goalSymbol.frame.size.height/2
        goalSymbol.delegate = self
        goalSymbolBaseView.addSubview(goalSymbol)
        //重なりの一番下に持っていく
        self.sendSubviewToBack(goalSymbolBaseView)
    }
    public func transformGoalSymbol(_ angle:Double,_ nowHeading:Double){
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {[weak self] in
            guard let _ = self else{return}
            self!.goalSymbolBaseView.transform = CGAffineTransform(rotationAngle: CGFloat(-nowHeading+angle) * CGFloat.pi / 180)
        }, completion: nil)
    }
}
