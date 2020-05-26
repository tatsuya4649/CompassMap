//
//  Title.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/25.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension NotificationSettingTableViewCell{
    ///タイトルラベルをセッティングするメソッド
    public func titleLabelSetting(_ title:String){
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 15, weight: .regular)
        titleLabel.textColor = .black
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint(x: 20 + titleLabel.frame.size.width/2, y: contentView.frame.size.height/2)
        contentView.addSubview(titleLabel)
    }
}
