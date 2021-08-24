//
//  KMAnnotation.swift
//  YiYangCloud
//
//  Created by 钟晓跃 on 2017/5/18.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import MapKit

class KMAnnotation: NSObject ,MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image:UIImage?
    
    init(coordinate:CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
