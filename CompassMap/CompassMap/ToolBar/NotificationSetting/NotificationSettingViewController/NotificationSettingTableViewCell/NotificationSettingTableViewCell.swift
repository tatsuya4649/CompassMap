//
//  NotificationSettingTableViewCell.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/25.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit

class NotificationSettingTableViewCell: UITableViewCell {

    var titleLabel : UILabel!
    var notificationSwitch : UISwitch!
    var haveSegmentControl : UISegmentedControl!
    var distancePicker : UIPickerView!
    var distanceSelection : Array<String>!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    public func setUp(_ indexPath:IndexPath,_ width:CGFloat){
        switch NotificationSettingTableViewSectionCount(rawValue:indexPath.section) {
        case .base:settingBase(indexPath,width)
        case .distance:distanceSetting(indexPath,width)
        case .have:haveSetting(indexPath,width)
        default:break
        }
    }

}
