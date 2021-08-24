//
//  LocationRecordVC.swift
//  YiYangCloud
//
//  Created by gary on 2017/4/27.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import MapKit

class LocationRecordVC: UIViewController {
    
    var model: FamilyMember = FamilyMember()
    var recordView:LocationRecordCollectionView? = nil
    var currentRecordModel: LocationRecord?
    
    
    @IBOutlet weak var mapView: MKMapView!
    var mapLoaded = false
    var annotation:KMAnnotation?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        recordView = Bundle.main.loadNibNamed("LocationRecordCollectionView", owner: nil, options: nil)?.last as? LocationRecordCollectionView
        recordView?.cellClickBlock = { model in self.relocation(model!) }
        recordView?.frame = (recordView?.originFrame)!
        self.view.addSubview(recordView!)
    }
    
    // 刷新坐标
    func relocation(_ model:LocationRecord?) {
        
        currentRecordModel = model
        guard mapLoaded , (currentRecordModel != nil) else { return }
        
        func locationAnnotationWithName(_ title:String, _ location:CLLocation, _ address:String) {
            
            if annotation != nil { mapView.removeAnnotation(annotation!) }
            
            annotation = KMAnnotation.init(coordinate: location.coordinate)
            annotation?.title = title
            annotation?.subtitle = address
            annotation?.image = UIImage.init(named: "pin_red")
            
            mapView.setCenter(location.coordinate, animated: true)
            mapView.setRegion(MKCoordinateRegionMakeWithDistance(location.coordinate, 10000, 10000), animated: false)
            mapView.addAnnotation(annotation!)
            mapView.selectAnnotation(annotation!, animated: true
            )
        }
        
        locationAnnotationWithName((currentRecordModel?.getTypeTitle())!, CLLocation.init(latitude: CLLocationDegrees(currentRecordModel!.lat!), longitude: CLLocationDegrees(currentRecordModel!.lng!)), currentRecordModel!.address!)
    }

    // 开始导航
    @IBAction func navigateButtonClick(_ sender: Any) {
        
        guard currentRecordModel != nil else {
            return
        }
        
        let currentLocation = MKMapItem.forCurrentLocation()
        let destinationLocation = MKMapItem.init(placemark: MKPlacemark.init(coordinate: CLLocationCoordinate2D.init(latitude: CLLocationDegrees(currentRecordModel!.lat!), longitude: CLLocationDegrees(currentRecordModel!.lng!)), addressDictionary: [:]))
            destinationLocation.name = currentRecordModel!.address
        
        let items = [currentLocation,destinationLocation]
        let dic = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                   MKLaunchOptionsMapTypeKey:NSNumber.init(value: MKMapType.standard.rawValue),
                   MKLaunchOptionsShowsTrafficKey:NSNumber.init(value: true)
            ] as [String : Any]
        
        // 打开苹果自身地图应用，并呈现特定的item
        MKMapItem.openMaps(with: items, launchOptions: dic)
    }
}

let AnnotationKey = "AnnotationKey"
extension LocationRecordVC:MKMapViewDelegate {
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        mapLoaded = true
        
        // 加载完后获取第一条数据（如果有数据的话）来显示
        if currentRecordModel == nil {
            currentRecordModel = recordView?.getFirstLocationRecord()
            relocation(currentRecordModel)
        }
        
//        relocation(currentRecordModel)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is KMAnnotation else {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationKey)
        
        if annotationView == nil  {
            annotationView = MKAnnotationView.init(annotation: annotation, reuseIdentifier: AnnotationKey)
            annotationView?.canShowCallout = true
        }
        annotationView?.annotation = annotation
        annotationView?.isSelected = true
        annotationView?.image = (annotation as! KMAnnotation).image
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        
        var temp = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(currentRecordModel!.lat!), longitude: CLLocationDegrees(currentRecordModel!.lng!))
        
        // 为了不被遮挡，需要向下偏移一点
        if temp.latitude >= 0.0003 {
            temp.latitude = temp.latitude - 0.0003
        }

        mapView.centerCoordinate = temp
    }

}
