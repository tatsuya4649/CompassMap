//
//  CompassToNormal.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/24.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension Compass{
    ///通常UIに変換する際に必要な設定を行う
    public func changeToNormalUI(){
        removeArrow()
        mapViewToNormal()
        mapToNormal()
        goalSymbolToNormal()
        directionLabelToNormal()
    }
    private func mapViewToNormal(){
        if mapView == nil{
            mapView = UIView()
            self.addSubview(mapView)
        }
        mapView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width*0.5, height: self.frame.size.width*0.5)
        mapView.layer.cornerRadius = mapView.frame.size.height/2
        mapView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        mapView.clipsToBounds = true
        mapView.alpha = 1.0
        self.bringSubviewToFront(mapView)
    }
    private func mapToNormal(){
        if map == nil{
            map = MKMapView()
            mapView.addSubview(map)
            if polyLine != nil{
                map.addOverlay(polyLine)
            }
            if let delegate = delegate{
                if let circle = delegate.goalCircle(){
                    map.addOverlay(circle)
                }
                if let userRegion = delegate.nowUserRegion(){
                    map.setRegion(userRegion, animated: false)
                }
            }
        }
        map.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.width)
        map.layer.cornerRadius = map.frame.size.height/2
        map.center = CGPoint(x: mapView.frame.size.width/2, y: mapView.frame.size.height/2)
        map.hero.id = CandidateCellHeroElement.map.rawValue
        map.mapType = .standard
        map.delegate = self
        map.showsUserLocation = true
        //コンパスは表示しない
        map.showsCompass = false
        //map.layer.borderWidth = 1
        //map.layer.borderColor =  UIColor.lightGray.cgColor
        addingMapHero()
    }
    private func goalSymbolToNormal(){
        if goalSymbolBaseView != nil{
            goalSymbolBaseView.removeFromSuperview()
            goalSymbolBaseView = nil
        }
        goalSymbolBaseView = HallowOutView()
        goalSymbolBaseView.frame = CGRect(x: 0, y: 0, width: mapView.frame.size.width + 2*(DEFAULT_GOAL_SYMBOL_MARGIN + DEFAULT_GOAL_SYMBOL_WIDTH_HEIGHT_SIZE), height: mapView.frame.size.height + 2*(DEFAULT_GOAL_SYMBOL_MARGIN + DEFAULT_GOAL_SYMBOL_WIDTH_HEIGHT_SIZE))
        goalSymbolBaseView.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        goalSymbolBaseView.center = mapView.center
        goalSymbolBaseView.layer.cornerRadius = goalSymbolBaseView.frame.size.height/2
        goalSymbolBaseView.hallowOut(normalMapSize/2)
        if goalSymbol != nil{
            goalSymbol.removeFromSuperview()
            goalSymbol = nil
        }
        goalSymbol = Symbol(frame: CGRect(x: 0, y: 0, width: DEFAULT_GOAL_SYMBOL_WIDTH_HEIGHT_SIZE, height: DEFAULT_GOAL_SYMBOL_WIDTH_HEIGHT_SIZE))
        goalSymbolBaseView.addSubview(goalSymbol)
        goalSymbol.backgroundColor = .black
        goalSymbol.center = CGPoint(x: goalSymbolBaseView.frame.size.width/2, y: goalSymbol.frame.size.height/2)
        goalSymbol.layer.cornerRadius = goalSymbol.frame.size.height/2
        goalSymbol.delegate = self
        goalSymbolBaseView.addSubview(goalSymbol)
        self.addSubview(goalSymbolBaseView)
        self.sendSubviewToBack(goalSymbolBaseView)
        guard let transform = nowTransformRotation else{return}
        goalSymbolBaseView.transform = transform
    }
    private func directionLabelToNormal(){
        removeDirectionLabel()
        frontLabel = settingLabel("前")
        backLabel = settingLabel("後")
        rightLabel = settingLabel("右")
        leftLabel = settingLabel("左")
        frontLabel.center = CGPoint(x: mapView.center.x, y: DEFAULT_MAP_DIRECTIONS_MARGIN + frontLabel.frame.size.height/2)
        backLabel.center = CGPoint(x: mapView.center.x, y: self.frame.size.height - DEFAULT_MAP_DIRECTIONS_MARGIN - backLabel.frame.size.height/2)
        rightLabel.center = CGPoint(x: self.frame.size.width - DEFAULT_MAP_DIRECTIONS_MARGIN - rightLabel.frame.size.width/2, y: mapView.center.y)
        leftLabel.center = CGPoint(x: DEFAULT_MAP_DIRECTIONS_MARGIN + leftLabel.frame.size.width/2, y: mapView.center.y)
        self.addSubview(frontLabel)
        self.addSubview(backLabel)
        self.addSubview(rightLabel)
        self.addSubview(leftLabel)
    }
}
