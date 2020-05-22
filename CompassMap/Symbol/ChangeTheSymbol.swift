//
//  ChangeTheSymbol.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension Symbol{
    ///シンボル をマップにするときの処理
    public func symbolToMap(){
        guard let symbolType = symbolType else{return}
        guard symbolType == .flag else{return}
        guard map == nil else{return}
        settingSymbolMap()
        //シンボルタイプを地図に変更する
        self.symbolType = .map
    }
    ///シンボルをフラッグにするときの処理
    public func symbolToFlag(){
        guard let symbolType = symbolType else{return}
        guard symbolType == .map else{return}
        removeMap()
        //シンボルタイプをフラッグに変更する
        self.symbolType = .flag
    }
    
}
