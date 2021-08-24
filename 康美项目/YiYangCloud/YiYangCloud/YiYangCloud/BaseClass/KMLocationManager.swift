//
//  KMLocationManager.swift
//  YiYangCloud
//
//  Created by 钟晓跃 on 2017/5/18.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import CoreLocation
import SVProgressHUD
import MapKit

class KMLocationManager: NSObject {
    
    typealias KMGeocodeCompletionHandler = (String?) -> Void
    typealias KMGeocodeLocationCompletionHandler = (CLLocation?) -> Void
    
    var address:String?
    
    var geo = CLGeocoder.init()
    
    var geoBlock:KMGeocodeCompletionHandler?
    
    static let shared = KMLocationManager()
    
    func startLocationWithLocation(location:CLLocation,resultBlock:@escaping KMGeocodeCompletionHandler){
        self.geo.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                resultBlock(nil)
                return
            }
            
            let realaddress = placemarks?.first?.name
            self.address = realaddress
            resultBlock(realaddress)
        })
    }
    
    func geocodeAddress(address:String?, complete:@escaping KMGeocodeLocationCompletionHandler) {
        self.geo.geocodeAddressString(address!) { (placemarks, error) in
            if error != nil && placemarks?.count == 0 {
                SVProgressHUD.showError(withStatus: "\(address!) 地址编码失败 \(error!)")
            }else {
                let location = placemarks?.first?.location
                complete(location)
            }
        }
    }
    
}
