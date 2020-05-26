//
//  CompassToArrow.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/24.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension Compass{
    public func changeToArrowUI(){
        mapViewToArrow()
        mapToArrow()
        goalSymbolToArrow()
        directionLabelToArrow()
        addingArrow()
    }
    private func mapViewToArrow(){
        if mapView != nil{
            mapView.alpha = 0
            //mapView.removeFromSuperview()
            //mapView = nil
        }
    }
    private func mapToArrow(){
        if map != nil{
            //map.removeFromSuperview()
            //map = nil
        }
    }
    private func goalSymbolToArrow(){
        if goalSymbolBaseView != nil{
            goalSymbolBaseView.removeFromSuperview()
            goalSymbolBaseView = nil
        }
        if goalSymbol != nil{
            goalSymbol.removeFromSuperview()
            goalSymbol = nil
        }
    }
    private func directionLabelToArrow(){
        if frontLabel != nil{
            frontLabel.removeFromSuperview()
            frontLabel = nil
        }
        if backLabel != nil{
            backLabel.removeFromSuperview()
            backLabel = nil
        }
        if rightLabel != nil{
            rightLabel.removeFromSuperview()
            rightLabel = nil
        }
        if leftLabel != nil{
            leftLabel.removeFromSuperview()
            leftLabel = nil
        }
        print(self.subviews)
    }
    private func addingArrow(){
        arrowView = ArrowView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.width))
        addSubview(arrowView)
        removeMapHero()
    }
    ///矢印ビューを取り除くときに使うメソッド
    public func removeArrow(){
        if arrowView != nil{
            arrowView.removeFromSuperview()
            arrowView = nil
        }
    }
}
