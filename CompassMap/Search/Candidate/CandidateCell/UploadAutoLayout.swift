//
//  UploadAutoLayout.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/21.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension CandidateCell{
    ///全体のUIパーツを整理してオートレイアウトを実装するためのメソッド
    public func updateAutoLayout(){
        //住所ラベルのオートレイアウト
        if addressLabel != nil{
            addressLabel.translatesAutoresizingMaskIntoConstraints = false
            addressLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
            addressLabel.widthAnchor.constraint(equalToConstant: addressLabel.frame.size.width).isActive = true
            addressLabel.heightAnchor.constraint(equalToConstant: addressLabel.frame.size.height).isActive = true
            addressLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        }
        //現在地から目的地までの距離ラベルのレイアウト
        if distanceLabel != nil{
            distanceLabel.translatesAutoresizingMaskIntoConstraints = false
            distanceLabel.topAnchor.constraint(equalTo: addressLabel != nil ? addressLabel.bottomAnchor : contentView.topAnchor, constant: 3).isActive = true
            distanceLabel.widthAnchor.constraint(equalToConstant: distanceLabel.frame.size.width).isActive = true
            distanceLabel.heightAnchor.constraint(equalToConstant: distanceLabel.frame.size.height).isActive = true
            distanceLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        }
        //地図のオートレイアウト
        if map != nil{
            map.translatesAutoresizingMaskIntoConstraints = false
            map.topAnchor.constraint(equalTo: distanceLabel != nil ? distanceLabel.bottomAnchor : addressLabel.bottomAnchor, constant: 3).isActive = true
            map.widthAnchor.constraint(equalToConstant: map.frame.size.width).isActive = true
            map.heightAnchor.constraint(equalToConstant: map.frame.size.height).isActive = true
            map.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
            map.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        }
    }
}
