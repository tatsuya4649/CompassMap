//
//  Symbol.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit
import MapKit

protocol SymbolDelegate : AnyObject{
    ///シンボル上にマップをセッティングした際にマップの中心を取得するためのデリゲートメソッド(この中心はゴール地点)
    func goalCircle() -> MKCircle?
}

class Symbol: UIView {
    weak var delegate : SymbolDelegate!
    var button : UIButton!
    var mapView : UIView!
    var map : SymbolMap!
    var symbolType : SymbolType!
    override init(frame: CGRect) {
        super.init(frame: frame)
        symbolButtonSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
