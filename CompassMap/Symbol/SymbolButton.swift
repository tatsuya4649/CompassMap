//
//  SymbolButton.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift

enum SymbolType{
    case flag
    case map
}
extension Symbol{
    ///ボタンのセッティングを行うメソッド
    public func symbolButtonSetting(){
        button = UIButton()
        button.backgroundColor = .white
        button.setTitle(String.fontAwesomeIcon(name: .flag), for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        button.sizeToFit()
        button.titleLabel?.sizeToFit()
        button.frame = self.frame
        button.layer.cornerRadius = button.frame.size.height/2
        button.addTarget(self, action: #selector(clickSymbol), for: .touchUpInside)
        button.layer.borderWidth = 0.0
        button.layer.borderColor = UIColor.white.cgColor
        self.addSubview(button)
        symbolType = .flag
    }
    
    @objc func clickSymbol(_ sender:UIButton){
        impact()
        print("シンボルがクリックされました")
        switch symbolType {
        case .flag:symbolToMap()
        case .map:symbolToFlag()
        default:break
        }
    }
    private func impact(){
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
}
