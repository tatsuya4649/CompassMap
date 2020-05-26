//
//  NotificationSettingViewController.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/25.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit

class NotificationSettingViewController: UIViewController {
    var tableView : UITableView!
    var tableSection : Array<String>!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "通知設定"
        //テーブルビューに関する初期設定
        tableViewSetting()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
