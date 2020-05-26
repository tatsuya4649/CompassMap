//
//  HallowOutView.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/25.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit

class HallowOutView: UIView {
    var hallowOutLayer : CALayer!
    var hallowOutRadius : CGFloat!
    var visualEffectView : UIVisualEffectView!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func hallowOut(_ hallowOutRadius:CGFloat){
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.height/2
        if visualEffectView != nil{
            visualEffectView.removeFromSuperview()
            visualEffectView = nil
        }
        visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        visualEffectView.layer.cornerRadius = visualEffectView.frame.size.height/2
        visualEffectView.frame = self.bounds
        visualEffectView.clipsToBounds = true
        self.addSubview(visualEffectView)
        if hallowOutLayer != nil{
            hallowOutLayer.removeFromSuperlayer()
            hallowOutLayer = nil
        }
        self.hallowOutRadius = hallowOutRadius
        // 繰り抜きたいレイヤーを作成する（今回は例として半透明にした）
        hallowOutLayer = CALayer()
        hallowOutLayer.bounds = self.bounds
        hallowOutLayer.position = CGPoint(
            x: self.bounds.size.width / 2.0,
            y: self.bounds.size.height / 2.0
        )
        hallowOutLayer.backgroundColor = UIColor.clear.cgColor
        hallowOutLayer.opacity = 0.5
        hallowOutLayer.cornerRadius = hallowOutLayer.frame.size.height/2

        // 四角いマスクレイヤーを作る
        let maskLayer = CAShapeLayer()
        maskLayer.bounds = hallowOutLayer.bounds

        // 塗りを反転させるために、pathに四角いマスクレイヤーを重ねる
        let ovalRect =  CGRect(
            x: (self.bounds.size.width / 2.0) - hallowOutRadius,
            y: (self.bounds.size.height / 2.0) - hallowOutRadius,
            width: hallowOutRadius * 2.0,
            height: hallowOutRadius * 2.0
        )
        let path =  UIBezierPath(ovalIn: ovalRect)
        path.append(UIBezierPath(rect: maskLayer.bounds))

        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.path = path.cgPath
        maskLayer.position = CGPoint(
            x: (self.bounds.size.width / 2.0),
            y: (self.bounds.size.height / 2.0)
        )
        // マスクのルールをeven/oddに設定する
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        hallowOutLayer.mask = maskLayer
        self.layer.addSublayer(hallowOutLayer)
        visualEffectView.layer.mask = maskLayer
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let _ = hallowOutRadius else{return self}
        let rect = CGRect(
            x: (self.bounds.size.width / 2.0) - self.hallowOutRadius,
            y: (self.bounds.size.height / 2.0) - self.hallowOutRadius,
            width: self.hallowOutRadius * 2.0,
            height: self.hallowOutRadius * 2.0
        )
        let hollowPath = UIBezierPath(roundedRect: rect, cornerRadius: self.hallowOutRadius)
        if !self.bounds.contains(point) || hollowPath.contains(point) {
            return nil
        }
        return self
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
