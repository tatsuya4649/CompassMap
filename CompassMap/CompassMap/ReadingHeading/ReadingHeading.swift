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
    case veryOff = "方向がとてもずれています。"
    ///めちゃくちゃずれているときの読み上げ文章
    case extremelyOff = "目的地に対して後ろ方向に進んでいます。"
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
    var nowDistance : Double!
    var direction : Direction!
    var distance : Distance!
    var userHeading : CLHeading!
    var reading : Reading!
    var userHeadingPocket : Double!
    ///通知をする設定距離
    var NOTIFICATION_DISTANCE : Double!
    ///通知をするかどうかの設定
    var NOTIFICATION_BOOL : Bool!
    ///通知設定で行った携帯の持ち方に関する設定
    var NOTIFICATION_HAVE : HaveSelection!
    init(_ goalLocation:CLLocation) {
        self.updateCount = Int(0)
        self.goalLocation = goalLocation
        //UserDefaultsを参照して、通知設定に合わせた通知を行うための処理
        if let notificationDistance = UserDefaults.standard.value(forKey: NotificationSettingElement.distance.rawValue) as? Int{
            NOTIFICATION_DISTANCE = Double(notificationDistance)
            nowDistance = Double(0)
        }else{
            NOTIFICATION_DISTANCE = NOTIFICATION_DISTANCE_DEFAULT_VALUE
        }
        if let notificationBool = UserDefaults.standard.value(forKey: NotificationSettingElement.notificationOnOrOff.rawValue) as? Bool{
            NOTIFICATION_BOOL = notificationBool
        }else{
            NOTIFICATION_BOOL = NOTIFICATION_BOOL_DEFAULT_VALUE
        }
        if let notificationHave = UserDefaults.standard.value(forKey: NotificationSettingElement.have.rawValue) as? String{
            NOTIFICATION_HAVE = HaveSelection(rawValue: notificationHave)
        }else{
            NOTIFICATION_HAVE = NOTIFICATION_HAVE_DEFAULT_VALUE
        }
    }
    ///ユーザーの位置情報が更新されたときに呼ばれるメソッド
    public func updateUserLocation(_ userLocation:CLLocation){
        print("読み上げヘッディングの位置情報も更新されました")
        //前回のユーザー位置情報から進んだ距離を算出する(2回目からの更新で)
        //前回からの距離を使って方角を算出する(ポケット用)
        if self.userLocation != nil{
            nowDistance += checkDistance(userLocation)
            self.userHeadingPocket = pocketDirection(self.userLocation,userLocation)
        }
        //ユーザー位置情報の更新を行う
        self.userLocation = userLocation
        //進んだ距離が通知距離を超えたら通知を発火し、nowDistanceを元に戻す
        guard nowDistance > NOTIFICATION_DISTANCE else{return}
        //通知用距離を0に戻す
        nowDistance = Double(0)
        //通知を行うかどうかの設定
        guard NOTIFICATION_BOOL else{return}
        //規定の距離を超えたら通知を行う
        notificationNowState()
    }
    ///更新されたユーザー位置情報と前回のユーザー位置情報との距離を算出する
    private func checkDistance(_ userLocation:CLLocation)->Double{
        distance = Distance(self.userLocation, userLocation)
        return distance.getTwoLocationDistance()
    }
    ///ユーザーの向いている方角が更新されたときに呼ばれるメソッド
    public func updateUserHeading(_ userHeading:CLHeading){
        self.userHeading = userHeading
    }
    ///前回の位置と今回の位置から方角を算出する
    private func pocketDirection(_ before:CLLocation,_ after:CLLocation)->Double{
        direction = Direction(before, after)
        return direction.getGoalDirectionFromNow()
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
        var differenceDirection = Double()
        ///手に持って歩いている場合は最新の方角を使用して、ユーザーの向いている方角を算出する
        if NOTIFICATION_HAVE == HaveSelection.hand{
            differenceDirection = -userTrueHeading+goalDirectionFromNow
        }else{
            //ポケットに入れて歩いている場合は、最新一つ前と最新のユーザー位置情報を使用して算出した方角を使用する(位置情報から方角を算出)
            if userHeadingPocket != nil{
                differenceDirection = -userHeadingPocket+goalDirectionFromNow
            }
        }
        //万が一0以下になってしまったら360を足してプラスにする
        if differenceDirection < 0{
            differenceDirection += 360
        }
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
    //ReadingHeadingStateからReadingHeadingStateStringへの変換を行うメソッド
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
    //ファイル名を探すときに使用するメソッド
    public func stringToFilename(_ state:ReadingHeadingStateString) -> ReadingHeadingStateAudioFileName?{
        switch state {
        case .veryGood:return ReadingHeadingStateAudioFileName.veryGood
        case .good:return ReadingHeadingStateAudioFileName.good
        case .littleOff:return ReadingHeadingStateAudioFileName.littleOff
        case .off:return ReadingHeadingStateAudioFileName.off
        case .veryOff:return ReadingHeadingStateAudioFileName.veryOff
        case .extremelyOff:return ReadingHeadingStateAudioFileName.extremelyOff
        case .opposition:return ReadingHeadingStateAudioFileName.opposition
        default:break
        }
        return nil
    }
    
    ///ここから初めて通知設定を行う
    private func readingNotificationSetting(_ state:ReadingHeadingState,_ differenceDirection:Double){
        guard let state = stateToStringState(state) else{return}
        reading = Reading(differenceDirection, state)
        reading.readingToAudioFile(completion: {[weak self] in
            //読み上げしてほしい文章を全て音声ファイルの中に格納できたら・・・
            guard let _ = self else{return}
            //ここから実際に通知を飛ばす処理をする
            self!.notificationSetting(state,differenceDirection)
        })
    }
    
}
