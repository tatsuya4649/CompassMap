//
//  TableView.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/25.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

private enum NotificationSettingTableViewSection : String{
    case base = "基本設定"
    case distance = "通知距離設定：設定した一定距離進んだときに1度現在向いている方角とゴールの方角が一致しているかどうかアナウンスします。"
    case have = "持ち方設定：持ち方によって方角の測定方法が変わります。\n ・手持ちの場合：iPhoneの向きからの目的地の方向を通知します。\n ・ポケットの場合：進んでいる位置情報を元に目的地の方向を通知します。"
    
    var title : String{
        return converted(NotificationSettingTableViewSection.self).rawValue
    }
    
    public init(_ section:Int){
        self.init(NotificationSettingTableViewSectionCount(rawValue: section))
    }
    
    private init<T>(_ t: T) {
        self = unsafeBitCast(t, to: NotificationSettingTableViewSection.self)
    }

    private func converted<T>(_ t: T.Type) -> T {
        return unsafeBitCast(self, to: t)
    }
}
public enum NotificationSettingTableViewSectionCount : Int{
    case base = 0
    case distance = 1
    case have = 2
}

extension NotificationSettingViewController:UITableViewDelegate,UITableViewDataSource{
    //セクションごとの行数を決める
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch NotificationSettingTableViewSectionCount(rawValue: section) {
        case .base:return 1
        case .distance:return 1
        case .have:return 1
        default:return 0
        }
    }
    //セクションごとのヘッダーのタイトルを返す
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NotificationSettingTableViewSection(section).title
    }
    //セクション数を決める
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableSection != nil ? tableSection.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationSettingCell", for: indexPath) as! NotificationSettingTableViewCell
        if cell.contentView.subviews.count > 0{
            for i in cell.contentView.subviews{
                i.removeFromSuperview()
            }
        }
        cell.setUp(indexPath,tableView.frame.size.width)
        return cell
    }
    
    ///通知設定に使用するテーブルビューを作成するためのメソッド
    public func tableViewSetting(){
        tableSection = [
            NotificationSettingTableViewSection.base.rawValue,
            NotificationSettingTableViewSection.distance.rawValue,
            NotificationSettingTableViewSection.have.rawValue
        ]
        let naviHeight = navigationController != nil ? navigationController!.navigationBar.frame.maxY : 0
        tableView = UITableView(frame: CGRect(x: 0, y: naviHeight, width: preferredContentSize.width, height: preferredContentSize.height), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NotificationSettingTableViewCell.self, forCellReuseIdentifier: "notificationSettingCell")
        tableView.allowsSelection = false
        view.addSubview(tableView)
    }
}
