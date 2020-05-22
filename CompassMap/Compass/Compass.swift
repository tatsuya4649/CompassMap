//
//  Compass.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Hero

protocol CompassDelegate : AnyObject {
    func goalCircle() -> MKCircle?
    ///現在地から目的地までのルートラインを作成してMKPolyLineだけ返してもらうデリゲートメソッド
    func nowToGoalPolyLine(completion:((MKRoute)->Void)?)
}
///現在地から目的地の場所を指すコンパス
final class Compass: UIView {
    weak var delegate : CompassDelegate!
    ///ユーザーが現在向いている方角を示す
    var nowDirection : CLHeading!
    var mapView : UIView!
    var map : MKMapView!
    //方向を示すラベル
    var frontLabel : UILabel!
    var backLabel : UILabel!
    var rightLabel : UILabel!
    var leftLabel : UILabel!
    var goalSymbol : Symbol!
    var goalSymbolBaseView : UIView!
    init(view:UIView){
        super.init(frame :CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))
        //self.backgroundColor = .red
        mapSetting()
        directionLabelSetting()
        goalSymbolSetting()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
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
