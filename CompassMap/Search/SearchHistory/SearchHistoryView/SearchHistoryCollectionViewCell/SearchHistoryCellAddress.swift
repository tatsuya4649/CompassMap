//
//  SearchHistoryCellAddress.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/24.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension SearchHistoryCollectionViewCell{
    ///住所が書かれたラベルのセッティングを行うメソッド
    public func addressLabelSetting(_ address:String){
        addressLabel = UILabel()
        addressDefaultFontSize = CGFloat(11.0)
        addressLabel.text = address
        addressLabel.font = .systemFont(ofSize: addressDefaultFontSize, weight: .regular)
        addressLabel.textColor = .black
        addressLabel.numberOfLines = 0
        addressLabel.lineBreakMode = .byWordWrapping
        addressLabel.sizeToFit()
        checkTheAddressLabel()
        addressLabel.center = CGPoint(x: contentView.frame.size.width/2, y: mapView.frame.maxY + (view.frame.size.height - mapView.frame.maxY)/2)
        view.addSubview(addressLabel)
    }
    ///使える広さとラベルの大きさを調べて使える広さになるまでフォントサイズを小さくするメソッド
    private func checkTheAddressLabel(){
        var size = addressLabel.sizeThatFits(CGSize(width: view.frame.size.width * 0.9, height: CGFloat.greatestFiniteMagnitude))
        let limitHeight = (view.frame.size.height - mapView.frame.maxY)*0.9
        guard var fontSize = addressDefaultFontSize else{return}
        ///ラベルの高さが制限高さよりも大きいときの処理
        while(size.height > limitHeight){
            print("検索履歴のラベルのフォントサイズを変更中：フォントサイズ\(fontSize)px")
            let fixFontSize = fontSize - 0.5
            addressLabel.font = .systemFont(ofSize: fixFontSize, weight: .regular)
            addressLabel.sizeToFit()
            size = addressLabel.sizeThatFits(CGSize(width: view.frame.size.width * 0.9, height: CGFloat.greatestFiniteMagnitude))
            addressLabel.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            addressLabel.center = CGPoint(x: contentView.frame.size.width/2, y: mapView.frame.maxY + (view.frame.size.height - mapView.frame.maxY)/2)
            fontSize = fixFontSize
        }
    }
}
