//
//  SearchHistoryView.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/24.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit
import CoreLocation

protocol SearchHistoryViewDelegate : AnyObject {
    ///実際にユーザーが検索履歴の項目をクリックしたときに呼び出されるデリゲートメソッド
    func userClickSearchHistory(_ cell:SearchHistoryCollectionViewCell,_ info:Dictionary<SearchElementValue,Any?>)
}

///検索履歴を表示するためのUIView。具体的には、コレクションビューをこの中で作成して表示する
class SearchHistoryView: UIView {
    weak var delegate : SearchHistoryViewDelegate!
    var searchHistoryCollectionView : UICollectionView!
    var searchHistoryCollectionViewFlowLayout : UICollectionViewFlowLayout!
    var info : Array<Dictionary<SearchElementValue,Any?>>!
    var userLocation : CLLocation!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init(info:Array<Dictionary<SearchElementValue,Any?>>,userLocation:CLLocation?,frame:CGRect) {
        self.init(frame:frame)
        self.info = info
        if userLocation != nil{
            self.userLocation = userLocation
        }
        collectionSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///検索画面で位置情報が更新されたときに呼び出されるメソッド(検索履歴セルの距離ラベルの値を変更するため)
    public func userLocationUpdate(_ userLocation:CLLocation){
        self.userLocation = userLocation
        collectionViewUpdateUserLocation(userLocation)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
