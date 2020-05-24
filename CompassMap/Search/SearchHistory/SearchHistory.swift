//
//  SearchHistory.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/23.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CoreLocation

extension SearchViewController{
    ///データベースに検索履歴に必要なデータを保存していく
    ///呼ばれるタイミング：ユーザーが検索候補をタップしてコンパス画面に移る直前
    public func addingSearchValue(_ candidateDictionary:Dictionary<SearchElementValue,Any?>){
        searchHistory = SearchHistoryOperation(candidateDictionary)
        //ユーザーが選択した場所をデータベースに検索履歴として保存するメソッド
        searchHistory.saveNewSearchHistory()
    }
    ///データベースに保存してある検索履歴にまつわるデータを全て取得するためのメソッド
    public func gettingSearchHistory(){
        searchHistory = SearchHistoryOperation()
        //ユーザーが過去に選択した場所が保存されているデータベースの中からデータを取得するメソッド
        guard let searchElementValueDicArray = searchHistory.gettingSearchHistory() else{return}
        guard searchElementValueDicArray.count > 0 else{return}
        //1つ以上の検索履歴があったら、UIのセッティングを行うメソッドを呼び出す
        searchHistorySetting(searchElementValueDicArray)
    }
}

///検索履歴としてデータベースに保存されているデータを操作するためのファイナルクラス
final class SearchHistoryOperation{
    var info : Dictionary<SearchElementValue,Any?>!
    var address : String!
    var circleRegion : CLCircularRegion!
    var searchHistoryArray : Array<SearchHistory>!
    var newSearchHistory : SearchHistory!
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    ///初期設定の際に必要なデータを受け取る(データ保存用初期メソッド)
    init(_ info:Dictionary<SearchElementValue,Any?>) {
        self.info = info
        //それぞれの要素を取り出して分解していく
        if let address = info[.address] as? String{
            self.address = address
        }
        if let region = info[.region] as? CLRegion{
            if let circleRegion = region as? CLCircularRegion{
                self.circleRegion = circleRegion
            }
        }
    }
    ///初期メソッドでは何もしない(データ取得用)
    init(){}
    ///新しく検索履歴として保存するときに呼び出すメソッド
    public func saveNewSearchHistory(){
        newSearchHistory = SearchHistory(context: context)
        searchHistoryArray = Array<SearchHistory>()
        if address != nil{
            newSearchHistory.address = address
        }
        if circleRegion != nil{
            newSearchHistory.circleCenterLatitude = Double(circleRegion.center.latitude)
            newSearchHistory.circleCenterLongitude = Double(circleRegion.center.longitude)
            newSearchHistory.circleRadius = Double(circleRegion.radius)
        }
        newSearchHistory.date = Date()
        searchHistoryArray.append(newSearchHistory)
        do{
            try context.save()
            print("検索履歴の保存に成功しました")
        }catch{
            print("検索履歴の保存に失敗しました。")
        }
    }
    ///保存してある検索履歴をデータベースから取得するためのメソッド
    public func gettingSearchHistory()->Array<Dictionary<SearchElementValue,Any?>>?{
        searchHistoryArray = Array<SearchHistory>()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchHistory")
        do{
            searchHistoryArray = try context.fetch(request) as! Array<SearchHistory>
            //最後に見やすく整理した値を返す
            return dataOrganization(searchHistoryArray)
        }catch{
            print("データベースからのデータの取得に失敗しました")
            return nil
        }
    }
    private func dataOrganization(_ searchHistoryArray:Array<SearchHistory>) -> Array<Dictionary<SearchElementValue,Any?>>{
        var searchElementValueDicArray = Array<Dictionary<SearchElementValue,Any?>>()
        for searchHistory in searchHistoryArray{
            var searchElementValueDic = Dictionary<SearchElementValue,Any?>()
            if let address =  searchHistory.address as? String{
                searchElementValueDic[.address] = address
            }
            guard let circleCenterLatitude = searchHistory.circleCenterLatitude as? Double else{continue}
            guard let circleCenterLongitude = searchHistory.circleCenterLongitude as? Double else{continue}
            guard let circleRadius = searchHistory.circleRadius as? Double else{continue}
            searchElementValueDic[.region] = CLCircularRegion(center: CLLocationCoordinate2D(latitude: circleCenterLatitude, longitude: circleCenterLongitude), radius: circleRadius, identifier: "circle")
            searchElementValueDicArray.append(searchElementValueDic)
        }
        //検索履歴を新しい順(最近順)にするためソートする
        //reversedで古い順から新しい順に変換される
        return searchElementValueDicArray.reversed()
    }
}
