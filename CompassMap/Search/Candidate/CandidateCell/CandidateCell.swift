//
//  CandidateCell.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/21.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit
import MapKit

protocol CandidateCellDelegate : AnyObject {
    func nowUserLocation()->CLLocation?
}

class CandidateCell: UITableViewCell {

    weak var delegate : CandidateCellDelegate!
    var addressLabel : UILabel!
    var distanceLabel : UILabel!
    var region : CLRegion!
    var map : MKMapView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setUp(_ candidate:Dictionary<SearchElementValue,Any?>){
        if let address = candidate[.address] as? String{
            settingAddressLabel(address)
        }
        if let region = candidate[.region] as? CLRegion{
            regionMapSetting(region)
            settingDistanceLabel(region)
        }
        updateAutoLayout()
        selectColorwhite()
    }
    
    private func selectColorwhite(){
        //選択されたときの色を設定
        let cellSelectedBgView = UIView()
        cellSelectedBgView.backgroundColor = .white
        self.selectedBackgroundView = cellSelectedBgView
    }
}
