//
//  NotifiationSetting.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/25.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension CompassMapViewController:UIPopoverPresentationControllerDelegate{
    ///コンパスの方角による通知を設定するビューコントローラーをセッティングする
    public func compassNotificationSetting(_ button:UIBarButtonItem){
        notificationSettingViewController = NotificationSettingViewController()
        let navigation = UINavigationController(rootViewController: notificationSettingViewController)
        navigation.modalPresentationStyle = .popover
        navigation.preferredContentSize = CGSize(width: 250, height: 350)
        notificationSettingViewController.preferredContentSize = navigation.preferredContentSize
        navigation.popoverPresentationController?.barButtonItem = button
        navigation.popoverPresentationController?.permittedArrowDirections = .any
        navigation.popoverPresentationController?.delegate = self
        present(navigation,animated: true)
    }
    ///iPhoneでポップオーバー表示する際に必要なデリゲートメソッド
    func adaptivePresentationStyle(for controller: UIPresentationController,
                                   traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
