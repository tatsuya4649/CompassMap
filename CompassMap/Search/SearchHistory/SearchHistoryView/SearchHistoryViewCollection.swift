//
//  File.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/24.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

let SEARCH_HISTORY_COLLECTIONVIEW_FLOWLAYOUT_INSET : CGFloat = 10.0

extension SearchHistoryView:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return info != nil ? info.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchHistoryCollectionViewCell", for: indexPath) as! SearchHistoryCollectionViewCell
        if cell.contentView.subviews.count > 0{
            for i in cell.contentView.subviews{
                i.removeFromSuperview()
            }
        }
        cell.setUp(info[indexPath.item],userLocation)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SearchHistoryCollectionViewCell else{return}
        //デリゲートに検索履歴がクリックされたことを伝える
        guard let delegate = delegate else{return}
        delegate.userClickSearchHistory(cell, cell.info)
    }
    
    ///コレクションビューを初期設定を行うためのメソッド
    public func collectionSetting(){
        searchHistoryCollectionViewFlowLayout = UICollectionViewFlowLayout()
        searchHistoryCollectionViewFlowLayout.itemSize = CGSize(width: self.frame.size.width/3, height: 8*(self.frame.size.height - 10)/10)
        searchHistoryCollectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: SEARCH_HISTORY_COLLECTIONVIEW_FLOWLAYOUT_INSET, bottom: 0, right: SEARCH_HISTORY_COLLECTIONVIEW_FLOWLAYOUT_INSET)
        searchHistoryCollectionViewFlowLayout.scrollDirection = .horizontal
        searchHistoryCollectionViewFlowLayout.minimumInteritemSpacing = 20
        
        searchHistoryCollectionView = UICollectionView(frame: self.frame, collectionViewLayout: searchHistoryCollectionViewFlowLayout)
        searchHistoryCollectionView.delegate = self
        searchHistoryCollectionView.dataSource = self
        searchHistoryCollectionView.backgroundColor = .clear
        searchHistoryCollectionView.register(SearchHistoryCollectionViewCell.self, forCellWithReuseIdentifier: "SearchHistoryCollectionViewCell")
        self.addSubview(searchHistoryCollectionView)
    }
    ///コレクションの全セルにユーザーの位置情報の更新があったことを伝える
    public func collectionViewUpdateUserLocation(_ userLocation:CLLocation){
        guard let _ = searchHistoryCollectionView else{return}
        guard let info = info else{return}
        guard info.count > 0 else{return}
        for number in 0..<info.count{
            print(number)
            //セルがあったら、ユーザー位置情報の更新と距離ラベルの更新を行う
            guard let cell = searchHistoryCollectionView.cellForItem(at: IndexPath(item: number, section: 0)) as? SearchHistoryCollectionViewCell else{continue}
            cell.userLocation = userLocation
            cell.updateDistanceLabel(userLocation)
        }
    }
}
