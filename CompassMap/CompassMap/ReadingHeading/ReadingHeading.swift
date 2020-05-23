//
//  ReadingHeading.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/23.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import CoreLocation
import AVFoundation

let READING_HEADING_UPDATE_COUNT : Int = 0

fileprivate enum ReadingHeadingState{
    case veryGood
    case good
    case littleOff
    case off
    case veryOff
    case extremelyOff
    case opposition
}
///ユーザーの現在向いている方角と目的地の方角がどれだけ離れているかどうかを表す列挙型
fileprivate enum ReadingHeadingStateDouble : Double{
    ///ほぼほぼ合っている
    case veryGood = 10
    ///まあまあ合っている
    case good = 30
    ///少しずれている
    case littleOff = 60
    ///ずれている
    case off = 90
    ///非常にずれている
    case veryOff = 120
    ///めちゃくちゃずれている
    case extremelyOff = 150
    ///ほぼほぼ反対を向いている
    case opposition = 170
}
public enum ReadingHeadingStateString : String{
    ///ほぼほぼ会っているときの読み上げ文章
    case veryGood = "その調子で進んでいきましょう。"
    ///まあまあ会っているときの読み上げ文章
    case good = "少しだけ方向がずれています。"
    ///少しずれているときの読み上げ文章
    case littleOff = "だんだん方向がずれてきています。"
    ///ずれているときに読み上げ文章
    case off = "方向がずれています。"
    ///非常にずれているときの読み上げ文章
    case veryOff = "非常に方向がずれています。"
    ///めちゃくちゃずれているときの読み上げ文章
    case extremelyOff = "目的地に対して後方向に進んでいます。"
    ///ほぼほぼ反対を向いているときの読み上げ文章
    case opposition = "目的地に対して反対方向に進んでいます。"
}
public enum ReadingHeadingStateAudioFileName : String{
    case veryGood = "veryGood.caf"
    case good = "good.caf"
    case littleOff = "littleOff.caf"
    case off = "off.caf"
    case veryOff = "veryOff.caf"
    case extremelyOff = "extremelyOff.caf"
    case opposition = "opposition.caf"
}
///位置情報の更新と読み上げ通知に関するファイナルクラス
final class ReadingHeading{
    var updateCount : Int!
    var goalLocation : CLLocation!
    var userLocation : CLLocation!
    var direction : Direction!
    var distance : Distance!
    var userHeading : CLHeading!
    init(_ goalLocation:CLLocation) {
        self.updateCount = Int(0)
        self.goalLocation = goalLocation
    }
    ///ユーザーの位置情報が更新されたときに呼ばれるメソッド
    public func updateUserLocation(_ userLocation:CLLocation){
        //ユーザー位置情報の更新を行う
        self.userLocation = userLocation
        //更新されたときに1ポイント追加していく
        updateCount += 1
        //10回以上更新されたらupdateCountを初期化して通知を行う
        guard updateCount >= READING_HEADING_UPDATE_COUNT else{return}
        notificationNowState()
        updateCount = 0
    }
    ///ユーザーの向いている方角が更新されたときに呼ばれるメソッド
    public func updateUserHeading(_ userHeading:CLHeading){
        self.userHeading = userHeading
    }
    ///今の状況を通知してあげる
    ///パターン1：ほぼほぼぴったりの方角を向いている
    ///パターン2：多少ずれている
    ///パターン3：かなりずれている
    ///パターン4：ほぼ反対を向いている
    private func notificationNowState(){
        guard let userLocation = userLocation else{return}
        guard let goalLocation = goalLocation else{return}
        guard let userHeading = userHeading else{return}
        direction = Direction(userLocation, goalLocation)
        let goalDirectionFromNow = direction.getGoalDirectionFromNow()
        let userTrueHeading = Double(userHeading.trueHeading)
        ///現在ユーザーが向いている角度とゴール地点の角度がどれくらい違うのかを示す(0~360)
        var differenceDirection = -userTrueHeading+goalDirectionFromNow
        //万が一0以下になってしまったら360を足してプラスにする
        if differenceDirection < 0{
            differenceDirection += 360
        }
        print("ここまできている？")
        //差からReadingHeadingStateを算出する
        guard let directionCheck = checkDirection(differenceDirection) else{return}
        readingNotificationSetting(directionCheck,differenceDirection)
    }
    private func checkDirection(_ differenceDirection:Double)->ReadingHeadingState?{
        ///方角を-180度~180度までに縮小させる
        var difference = differenceDirection > 180 ? differenceDirection - 360 : differenceDirection
        ///差を絶対値にすることで330度も30度も同じ方角差になる
        var absDifference = abs(differenceDirection)
        if absDifference < ReadingHeadingStateDouble.veryGood.rawValue{
            return ReadingHeadingState.veryGood
        }else if absDifference < ReadingHeadingStateDouble.good.rawValue{
            return ReadingHeadingState.good
        }else if absDifference < ReadingHeadingStateDouble.littleOff.rawValue{
            return ReadingHeadingState.littleOff
        }else if absDifference < ReadingHeadingStateDouble.off.rawValue{
            return ReadingHeadingState.off
        }else if absDifference < ReadingHeadingStateDouble.veryOff.rawValue{
            return ReadingHeadingState.veryOff
        }else if absDifference < ReadingHeadingStateDouble.extremelyOff.rawValue{
            return ReadingHeadingState.extremelyOff
        }else if absDifference < ReadingHeadingStateDouble.opposition.rawValue{
            return ReadingHeadingState.opposition
        }
        return nil
    }
    ///ユーザーの向きに応じた文章を返すメソッド
    private func readingSentences(_ state:ReadingHeadingState) -> String{
        var readingSentences = String()
        switch state {
        case .veryGood:readingSentences = ReadingHeadingStateString.veryGood.rawValue
        case .good:readingSentences = ReadingHeadingStateString.good.rawValue
        case .littleOff:readingSentences = ReadingHeadingStateString.littleOff.rawValue
        case .off:readingSentences = ReadingHeadingStateString.off.rawValue
        case .veryOff:readingSentences = ReadingHeadingStateString.veryOff.rawValue
        case .extremelyOff:readingSentences = ReadingHeadingStateString.extremelyOff.rawValue
        case .opposition:readingSentences = ReadingHeadingStateString.opposition.rawValue
        default:break
        }
        return readingSentences
    }
    private func stateToStringState(_ state:ReadingHeadingState) -> ReadingHeadingStateString?{
        switch state {
        case .veryGood:return ReadingHeadingStateString.veryGood
        case .good:return ReadingHeadingStateString.good
        case .littleOff:return ReadingHeadingStateString.littleOff
        case .off:return ReadingHeadingStateString.off
        case .veryOff:return ReadingHeadingStateString.veryOff
        case .extremelyOff:return ReadingHeadingStateString.extremelyOff
        case .opposition:return ReadingHeadingStateString.opposition
        default:break
        }
        return nil
    }
    
    ///ここで初めて通知設定を行う
    private func readingNotificationSetting(_ state:ReadingHeadingState,_ differenceDirection:Double){
        
    }
}
