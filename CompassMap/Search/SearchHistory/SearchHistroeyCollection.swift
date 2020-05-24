//
//  SearchHistroeyCollection.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/23.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

let SEARCH_HISTORY_VIEW_MARGIN : CGFloat = 50.0

extension SearchViewController:SearchHistoryViewDelegate{
    func userClickSearchHistory(_ cell: SearchHistoryCollectionViewCell, _ info: Dictionary<SearchElementValue, Any?>) {
        print("検索履歴がクリックされました：\(info[.address] != nil ? info[.address]! : nil)")
        //検索候補にヒーロー遷移がついているかもしれないのでヒーローIDを削除する
        removeCandidateHero()
        //検索履歴にヒーロー遷移がついているかもしれないのでヒーローIDを削除する
        searchHistoryHeroRemove()
        //全てのヒーロー遷移を取り除いてから、クリックされたセルにヒーローIDを追加する
        cell.addingHero()
        //遷移させる
        compassMapViewController = CompassMapViewController()
        compassMapViewController.modalPresentationStyle = .fullScreen
        compassMapViewController.setUp(info,userLocation)
        present(compassMapViewController, animated: true, completion: {[weak self] in
            guard let _ = self else{return}
            self!.compassMapViewController.resetSizeCompassMap()
        })
    }
    ///保存されている検索履歴が１つでもあればコレクションとして表示する際に必要になるビューに関するセッティングを行うメソッド
    public func searchHistorySetting(_ array:Array<Dictionary<SearchElementValue, Any?>>){
        guard let _ = textField else{return}
        let statusHeight = UIApplication.shared.statusBarFrame.size.height
        print(textField.frame.minY - (statusHeight + SEARCH_HISTORY_VIEW_MARGIN))
        searchHistoryView = SearchHistoryView(info: array,userLocation: userLocation, frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: textField.frame.minY - (statusHeight + SEARCH_HISTORY_VIEW_MARGIN)))
        searchHistoryView.delegate = self
        searchHistoryView.center = CGPoint(x: view.center.x, y: statusHeight + SEARCH_HISTORY_VIEW_MARGIN/2 + searchHistoryView.frame.size.height/2)
        view.addSubview(searchHistoryView)
    }
    ///ユーザーの位置情報が更新されたときに呼び出されるメソッド
    public func searchHistoryViewUpdateUserLocation(_ userLocation:CLLocation){
        guard let searchHistoryView = searchHistoryView else{return}
        searchHistoryView.userLocationUpdate(userLocation)
    }
    ///検索履歴のセルのヒーローを削除するメソッド
    public func searchHistoryHeroRemove(){
        guard let searchHistoryView = searchHistoryView else{return}
        searchHistoryView.collectionViewResetHero()
    }
}
