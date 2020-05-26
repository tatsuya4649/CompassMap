//
//  FloatingPanelMapController.swift
//  CompassMap
//
//  Created by 下川達也 on 2020/05/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit
import MapKit

let FLOATINGPANEL_MAP_TOOLBAR_HEIGHT : CGFloat = 50.0

protocol FloatingPanelMapControllerDelegate : AnyObject {
    func closeMap()
}

class FloatingPanelMapController: UIViewController,MKMapViewDelegate {
    weak var delegate : FloatingPanelMapControllerDelegate!
    var map : MKMapView!
    var toolBar : UIToolbar!
    var closeButton : UIBarButtonItem!
    var changeMapTypeButton : UIBarButtonItem!
    var shareButton : UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    public func setUp(_ mapView:MKMapView){
        toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: FLOATINGPANEL_MAP_TOOLBAR_HEIGHT))
        closeButton = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .chevronDown, style: .solid, textColor: .black, size: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(closeMap))
        changeMapTypeButton = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .syncAlt, style: .solid, textColor: .black, size: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(changeMapType))
        shareButton = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .shareSquare, style: .solid, textColor: .black, size: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysOriginal), style: .done, target: nil, action: #selector(shareButtonClick))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.items = [closeButton,flexibleSpace,flexibleSpace,flexibleSpace,flexibleSpace,flexibleSpace,flexibleSpace,flexibleSpace,flexibleSpace,flexibleSpace,flexibleSpace,flexibleSpace,flexibleSpace,changeMapTypeButton,flexibleSpace,shareButton]
        view.addSubview(toolBar)
        map = MKMapView(frame: CGRect(x: 0, y: FLOATINGPANEL_MAP_TOOLBAR_HEIGHT, width: view.frame.size.width, height: view.frame.size.height - FLOATINGPANEL_MAP_TOOLBAR_HEIGHT))
        map.delegate = self
        map.showsUserLocation = true
        map.showsScale = true
        map.showsTraffic = true
        map.showsBuildings = true
        view.addSubview(map)
        map.setRegion(mapView.region, animated: false)
        map.setUserTrackingMode(.followWithHeading, animated: true)
        guard mapView.overlays.count > 0 else{return}
        for overlay in mapView.overlays{
            map.addOverlay(overlay)
        }
    }
    
    @objc func changeMapType(_ sender:UIBarButtonItem){
        impact()
        switch map.mapType {
        case .standard:map.mapType = .hybrid
        case .hybrid:map.mapType = .satellite
        case .satellite:map.mapType = .hybridFlyover
        case .hybridFlyover:map.mapType = .satelliteFlyover
        case .satelliteFlyover:map.mapType = .mutedStandard
        case .mutedStandard:map.mapType = .standard
        default:break
        }
    }
    
    @objc func shareButtonClick(_ sender:UIBarButtonItem){
        guard let image = gettingViewImage() else{return}
        impact()
        var activityItems = Array<Any>()
        activityItems.append(image)
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    private func impact(){
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let _ = overlay as? MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = DEFAULT_CIRCLE_STROKECOLOR
            circle.fillColor = DEFAULT_CIRCLE_FILLCOLOR
            circle.lineWidth = DEFAULT_CIRCLE_LINEWIDTH
            return circle
        }
        if let polyLine = overlay as? MKPolyline{
            let routeRenderer = MKPolylineRenderer(polyline:polyLine)
            routeRenderer.lineWidth = MAP_POLYLINE_SIZE
            routeRenderer.strokeColor = MAP_POLYLINE_COLOR
            return routeRenderer
        }
        return MKOverlayRenderer()
    }
    
    private func gettingViewImage()->UIImage?{
        let rect = view.bounds
        // ビットマップ画像のcontextを作成する
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context : CGContext = UIGraphicsGetCurrentContext()!
        // view内の描画をcontextに複写する
        view.layer.render(in: context)
        // contextのビットマップをUIImageとして取得する
        if let image : UIImage = UIGraphicsGetImageFromCurrentImageContext(){
            // contextを閉じる
            UIGraphicsEndImageContext()
            return image
        }else{
            //コンテキストを閉じる
            UIGraphicsEndImageContext()
            return nil
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //地図を閉じるためのボタン
    @objc func closeMap(_ sender:UIBarButtonItem){
        guard let delegate = delegate else{return}
        delegate.closeMap()
    }
}
