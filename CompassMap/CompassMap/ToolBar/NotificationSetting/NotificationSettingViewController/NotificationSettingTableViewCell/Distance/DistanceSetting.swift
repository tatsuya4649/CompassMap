//
//  DistanceSettin.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/25.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

private enum DistanceSelection{
    case one_hundred
    case two_hundred
    case three_hundred
    case four_hundred
    case five_hundred
    case six_hundred
    case seven_hundred
    case eight_hundred
    case nine_hundred
    case one_thousand
    
    public var int : Int{
        return converted(DistanceSelectionInt.self).rawValue
    }
    public var string : String{
        return converted(DistanceSelectionString.self).rawValue
    }
    init(string:String){
        self.init(DistanceSelectionString(rawValue: string))
    }
    init(int:Int){
        self.init(DistanceSelectionInt(rawValue: int))
    }
    private init<T>(_ t:T){
        self = unsafeBitCast(t, to: DistanceSelection.self)
    }
    private func converted<T>(_ t: T.Type) -> T {
        return unsafeBitCast(self, to: t)
    }
}
private enum DistanceSelectionString:String{
    case one_hundred = "100"
    case two_hundred = "200"
    case three_hundred = "300"
    case four_hundred = "400"
    case five_hundred = "500"
    case six_hundred = "600"
    case seven_hundred = "700"
    case eight_hundred = "800"
    case nine_hundred = "900"
    case one_thousand = "1000"
}
private enum DistanceSelectionInt:Int{
    case one_hundred = 100
    case two_hundred = 200
    case three_hundred = 300
    case four_hundred = 400
    case five_hundred = 500
    case six_hundred = 600
    case seven_hundred = 700
    case eight_hundred = 800
    case nine_hundred = 900
    case one_thousand = 1000
}
private enum DistanceSelectionIndex:Int{
    case one_hundred = 0
    case two_hundred = 1
    case three_hundred = 2
    case four_hundred = 3
    case five_hundred = 4
    case six_hundred = 5
    case seven_hundred = 6
    case eight_hundred = 7
    case nine_hundred = 8
    case one_thousand = 9
    
    init(_ distance:Int){
        self.init(DistanceSelectionInt(rawValue: distance))
    }
    private init<T>(_ t:T){
        self = unsafeBitCast(t, to: DistanceSelectionIndex.self)
    }
}

extension NotificationSettingTableViewCell:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return distanceSelection != nil ? distanceSelection.count : 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return distanceSelection != nil ? distanceSelection[row] : nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("距離が新たに選択されました")
        ///選択されるたびにUserDefaultsに保存する
        notificationDistanceSave(DistanceSelection(string: distanceSelection[row]).int)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = distanceSelection[row]
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .black
        label.sizeToFit()
        return label
    }
    
    ///通知距離設定欄のセッティングをするメソッド
    public func distanceSetting(_ indexPath:IndexPath,_ width:CGFloat){
        let row = indexPath.row
        switch row {
        case 0:
            titleLabelSetting("距離")
            distancePickerSetting(width)
        default:break
        }
    }
    ///距離を選択させるためのピッカーを用意します。
    private func distancePickerSetting(_ width:CGFloat){
        distanceSelection = [
            DistanceSelection.one_hundred.string,
            DistanceSelection.two_hundred.string,
            DistanceSelection.three_hundred.string,
            DistanceSelection.four_hundred.string,
            DistanceSelection.five_hundred.string,
            DistanceSelection.six_hundred.string,
            DistanceSelection.seven_hundred.string,
            DistanceSelection.eight_hundred.string,
            DistanceSelection.nine_hundred.string,
            DistanceSelection.one_thousand.string
        ]
        distancePicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 0.4*(width - titleLabel.frame.maxX), height: contentView.frame.size.height))
        distancePicker.center = CGPoint(x: width - 10 - distancePicker.frame.size.width/2, y: contentView.frame.size.height/2)
        distancePicker.delegate = self
        distancePicker.dataSource = self
        distancePicker.selectRow(4, inComponent: 0, animated: false)
        if let distanceInt = UserDefaults.standard.value(forKey: NotificationSettingElement.distance.rawValue) as? Int{
            distancePicker.selectRow(DistanceSelectionIndex(distanceInt).rawValue, inComponent: 0, animated: false)
        }
        contentView.addSubview(distancePicker)
        let distanceUnitLabel = UILabel()
        distanceUnitLabel.text = "m"
        distanceUnitLabel.font = .systemFont(ofSize: 12, weight: .light)
        distanceUnitLabel.textColor = .gray
        distanceUnitLabel.sizeToFit()
        distanceUnitLabel.center = CGPoint(x: distancePicker.frame.size.width - 5 - distanceUnitLabel.frame.size.width/2, y: distancePicker.frame.size.height/2)
        distancePicker.addSubview(distanceUnitLabel)
    }
}
