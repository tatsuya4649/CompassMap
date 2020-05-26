//
//  ToolBar.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift
import FloatingPanel

extension CompassMapViewController:FloatingPanelControllerDelegate,FloatingPanelMapControllerDelegate{
    
    ///ツールバーを表示させるためのメソッド
    public func toolBarSetting(){
        toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width*0.7, height: 50))
        mapButtonItem = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .map, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(mapButtonItemClick))
        notificationButtonItem = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .bell, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(notificationButtonItemClick))
        shareButtonItem = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .shareSquare, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(shareButtonItemClick))
        changeCompassButtonItem = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .syncAlt, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(changeCompassButtonItemClick))
        toolBar.layer.cornerRadius = toolBar.frame.size.height/2
        toolBar.barTintColor = .black
        toolBar.clipsToBounds = true
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [flexibleSpace,mapButtonItem,flexibleSpace,notificationButtonItem,flexibleSpace,shareButtonItem,flexibleSpace,changeCompassButtonItem,flexibleSpace]
        toolBar.center = CGPoint(x: view.center.x, y: compass.frame.maxY + 20 + toolBar.frame.size.height/2)
        view.addSubview(toolBar)
    }
    private func impact(){
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    ///ツールバーの地図ボタンが押されたときの処理
    @objc func mapButtonItemClick(_ sender:UIBarButtonItem){
        print("ツールバーの地図ボタンがクリックされました")
        impact()
        guard fpc == nil else{
            fpc.removePanelFromParent(animated: true)
            fpc = nil
            panGestureSetting()
            return
        }
        fpc = FloatingPanelController()
        fpc.isRemovalInteractionEnabled = false
        fpcMap = FloatingPanelMapController()
        fpcMap.delegate = self
        fpcMap.setUp(compass.map)
        fpc.set(contentViewController: fpcMap)
        fpc.delegate = self
        fpc.addPanel(toParent: self)
        fpc.move(to: .hidden, animated: false)
        fpc.move(to: .tip, animated: true)
        //fpcが出現している間は画面のパンジェスチャーを解除する
        removePanGesture()
    }
    func closeMap() {
        impact()
        fpc.removePanelFromParent(animated: true)
        fpc = nil
        panGestureSetting()
    }
    ///ツールバーの通知ボタンが押されたときの処理
    @objc func notificationButtonItemClick(_ sender:UIBarButtonItem){
        print("ツールバーの通知ボタンがクリックされました")
        impact()
        compassNotificationSetting(sender)
    }
    ///ツールバーのアクションボタンが押されたときの処理
    @objc func shareButtonItemClick(_ sender:UIBarButtonItem){
        print("ツールバーのアクションボタンがクリックされました")
        guard let image = gettingViewImage() else{return}
        impact()
        var activityItems = Array<Any>()
        activityItems.append(image)
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    private func gettingViewImage()->UIImage?{
        let rect = view.bounds
        // ビットマップ画像のcontextを作成する
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context : CGContext = UIGraphicsGetCurrentContext()!
        // view内の描画をcontextに複写する
        view.layer.render(in: context)
        // contextのビットマップをUIImageとして取得する
        if let image : UIImage = UIGraphicsGetImageFromCurrentImageContext(){
            // contextを閉じる
            UIGraphicsEndImageContext()
            return image
        }else{
            //コンテキストを閉じる
            UIGraphicsEndImageContext()
            return nil
        }
    }
    
    @objc func changeCompassButtonItemClick(_ sender:UIBarButtonItem){
        impact()
        changeTheCompass()
    }
}
