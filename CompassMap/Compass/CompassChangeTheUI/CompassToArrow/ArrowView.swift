//
//  ArrowView.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/24.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit

let TRIANGLE_WIDTH : CGFloat = 10.0

class ArrowView: UIView {
    var triangle : UIBezierPath!
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        clipsToBounds = true
        layer.cornerRadius = frame.size.height/2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        triangle = UIBezierPath()
        triangle.move(to: CGPoint(x: self.frame.size.width/2, y: self.bounds.minY + 20))
        triangle.addLine(to:CGPoint(x: self.frame.size.width/2 - TRIANGLE_WIDTH, y: self.frame.size.height/2))
        triangle.addCurve(to: CGPoint(x: self.frame.size.width/2 + TRIANGLE_WIDTH, y: self.frame.size.height/2), controlPoint1: CGPoint(x: self.frame.size.width/2 - TRIANGLE_WIDTH, y: 15 + self.frame.size.height/2), controlPoint2: CGPoint(x: self.frame.size.width/2 + TRIANGLE_WIDTH , y: 15 + self.frame.size.height/2))
        triangle.addLine(to:CGPoint(x: self.frame.size.width/2, y: self.bounds.minY + 20))
        triangle.close()
        UIColor.red.setFill()
        triangle.fill()
        UIColor.red.setStroke()
        triangle.lineWidth = 1.0
        // 線を塗りつぶす
        triangle.stroke()
    }

}
