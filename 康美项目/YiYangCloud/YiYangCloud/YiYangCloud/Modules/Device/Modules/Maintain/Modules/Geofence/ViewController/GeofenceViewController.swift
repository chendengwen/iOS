//
//  GeofenceViewController.swift
//  YiYangCloud
//
//  Created by 钟晓跃 on 2017/5/18.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import SVProgressHUD

class GeofenceViewController: UIViewController {
    
    lazy var locationManager:CLLocationManager = {
        let locationManager = CLLocationManager.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }()
    //地图视图
    var mapView = MKMapView.init()
    //电子围栏位置大头针
    var redAnnotation:KMAnnotation?
    //手机位置大头针
    var blueAnnotation:KMAnnotation?
    //电子围栏模型
    var geofenceModel:KMGeofenceModel = KMGeofenceModel.init()
    //电子围栏位置
    var currentCoord:CLLocationCoordinate2D?
    //电子围栏半径
    var currentRadius:CLLocationDistance?
    //地址
    var topWhiteLabel = UILabel.init()
    //搜索框
    var addressSearchBar = UISearchBar.init()
    //定位手机按钮
    var arriveMyLocationButton = UIButton.init()
    //地址
    var addressString:String?
    //搜索地址列表
    lazy var placeTableView:UITableView = {
        let tableView = UITableView.init()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    //地址信息
    var placeMarks = [MKMapItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configNavBar()
        self.configView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.placeTableView.isHidden = true
        self.addressSearchBar.endEditing(true)
    }
}

//UI
extension GeofenceViewController{
    func configNavBar(){
        self.title = "电子围栏"
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: .done, target: self, action: #selector(self.saveAction(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    
    func configView(){
        self.view.backgroundColor = UIColor.white
        
        self.mapView.delegate = self
        self.view.addSubview(self.mapView)
        self.mapView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        self.addressSearchBar.barTintColor = UIColor.white.withAlphaComponent(0.5)
        self.addressSearchBar.backgroundImage = UIImage.init(named: "kuang")
        self.addressSearchBar.delegate = self
        self.mapView.addSubview(self.addressSearchBar)
        self.addressSearchBar.placeholder = "搜索"
        self.addressSearchBar.snp.makeConstraints { (make) in
            make.right.equalTo(self.mapView).offset(-35)
            make.left.equalTo(self.mapView).offset(35)
            make.top.equalTo(self.mapView).offset(22)
            make.height.equalTo(35)
        }
        
        self.view.addSubview(self.placeTableView)
        self.placeTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.addressSearchBar.snp.bottom).offset(5)
            make.width.centerX.equalTo(self.addressSearchBar)
            make.height.equalTo(200)
        }
        
        self.placeTableView.isHidden = (self.placeMarks.count == 0)
        
        self.topWhiteLabel.text = "地址:"
        self.topWhiteLabel.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.topWhiteLabel.font = UIFont.systemFont(ofSize: 10)
        self.topWhiteLabel.textAlignment = .center
        self.view.addSubview(self.topWhiteLabel)
        self.topWhiteLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.mapView)
            make.height.equalTo(20)
        }
        
        let bottomView = UIView.init()
        bottomView.backgroundColor = UIColor.white
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.height.equalTo(107)
            make.left.right.bottom.equalTo(self.view)
        }
        
        let subView_top = UIView.init()
        subView_top.backgroundColor = UIColor.white
        bottomView.addSubview(subView_top)
        subView_top.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(bottomView)
            make.height.equalTo(47)
        }
        
        let tisLab = UILabel.init()
        tisLab.text = "点击地图,获取电子围栏中心点"
        tisLab.font = UIFont.systemFont(ofSize: 12)
        tisLab.textColor = UIColor.init(hex: 0x999999)
        subView_top.addSubview(tisLab)
        tisLab.snp.makeConstraints { (make) in
            make.center.equalTo(subView_top)
        }
        
        let separatorView = UIView.init()
        separatorView.backgroundColor = UIColor.init(hex: 0xF7F7F7)
        bottomView.addSubview(separatorView)
        separatorView.snp.makeConstraints { (make) in
            make.top.equalTo(subView_top.snp.bottom)
            make.left.right.equalTo(subView_top)
            make.height.equalTo(1)
        }
        
        let subView_bottom = UIView.init()
        subView_bottom.backgroundColor = UIColor.white
        bottomView.addSubview(subView_bottom)
        subView_bottom.snp.makeConstraints { (make) in
            make.top.equalTo(separatorView.snp.bottom)
            make.left.right.bottom.equalTo(bottomView)
        }
        
        let titleLab = UILabel.init()
        titleLab.font = UIFont.systemFont(ofSize: 14)
        titleLab.textColor = UIColor.init(hex: 0x666666)
        titleLab.text = "开启围栏"
        subView_bottom.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(subView_bottom).offset(20)
            make.centerY.equalTo(subView_bottom)
        }
        
        let isSwitch = UISwitch.init()
        isSwitch.addTarget(self, action: #selector(self.changeSwitch(sender:)), for: .valueChanged)
        subView_bottom.addSubview(isSwitch)
        isSwitch.snp.makeConstraints { (make) in
            make.centerY.equalTo(subView_bottom)
            make.right.equalTo(subView_bottom).offset(-25)
        }
        
        
        self.arriveMyLocationButton.setImage(UIImage.init(named: "myLocation"), for: .normal)
        self.arriveMyLocationButton.setImage(UIImage.init(named: "myLocationEnable"), for: .highlighted)
        self.arriveMyLocationButton.backgroundColor = UIColor.white
        self.arriveMyLocationButton.addTarget(self, action: #selector(self.arriveMyLocationButton(_:)), for: .touchUpInside)
        self.view.addSubview(self.arriveMyLocationButton)
        self.arriveMyLocationButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.left.equalTo(self.mapView).offset(25)
            make.bottom.equalTo(bottomView.snp.top).offset(-25)
        }
        let mTap = UITapGestureRecognizer.init(target: self, action: #selector(self.mapDidTapWithGesture(gestureRecognizer:)))
        self.mapView.addGestureRecognizer(mTap)
    }
    
    //地图上添加一个电子围栏圆圈
    func addGeofenceWithCenterCoordinate(coord: CLLocationCoordinate2D,radius:CLLocationDistance){
        self.mapView.removeOverlays(self.mapView.overlays)
        let circle = MKCircle.init(center: coord, radius: radius)
        self.mapView.addOverlays([circle])
    }
    
    //地图上添加一个大头针
    func addUserLocationAnnotation(coord:CLLocationCoordinate2D){
        if (self.redAnnotation != nil) {
            self.mapView.removeAnnotation(self.redAnnotation!)
        }
        self.redAnnotation = KMAnnotation.init(coordinate: coord)
        self.redAnnotation?.image = UIImage.init(named: "mapred")
        
        self.mapView.addAnnotation(self.redAnnotation!)
    }
    
    //地图上添加一个大头针
    func addUserCurrentLocationAnnotation(coord:CLLocationCoordinate2D){
        if (self.blueAnnotation != nil) {
            self.mapView.removeAnnotation(self.blueAnnotation!)
        }
        self.blueAnnotation = KMAnnotation.init(coordinate: coord)
        self.blueAnnotation?.image = UIImage.init(named: "maplan")
        
        self.mapView.addAnnotation(self.blueAnnotation!)
    }
    
    //地图上添加电子围栏范围
    func updateUIWithGeofenceModel(geofence:KMGeofenceModel){
        self.currentCoord = CLLocationCoordinate2DMake(geofence.latitude!, geofence.longitude!)
        self.currentRadius = geofence.radius
        //电子围栏范围
        self.addGeofenceWithCenterCoordinate(coord: self.currentCoord!, radius: self.currentRadius!)
        //电子围栏大头针
        self.addUserLocationAnnotation(coord: self.currentCoord!)
        //获取地址信息
        let location = CLLocation.init(latitude: (self.currentCoord?.latitude)!, longitude: (self.currentCoord?.longitude)!)
        if self.addressString != nil {
            self.topWhiteLabel.text = self.addressString
        }else{
            KMLocationManager.shared.startLocationWithLocation(location: location) { (address) in
                if address != nil {
                    self.topWhiteLabel.text = "地址:\(address!)"
                }
            }
        }
    }
}

//Action
extension GeofenceViewController{
    func changeSwitch(sender:UISwitch){
        
    }
    
    //保存数据
    func saveAction(_ sender: UIBarButtonItem){
        
    }
    
    //地图点击手势
    func mapDidTapWithGesture(gestureRecognizer:UIGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: self.mapView)
        let touchMapCoordinate = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
        
        self.geofenceModel.longitude = touchMapCoordinate.longitude
        self.geofenceModel.latitude = touchMapCoordinate.latitude
        self.geofenceModel.radius = 500
        self.addressString = nil
        self.updateUIWithGeofenceModel(geofence: self.geofenceModel)
    }
    
    func arriveMyLocationButton(_ sender:UIButton){
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.startUpdatingLocation()
        }
    }
}

//CLLocationManagerDelegate
extension GeofenceViewController:CLLocationManagerDelegate{
    //手机当前位置
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentlocation = locations.last
        
        if currentlocation != nil {
            print("当前纬度:\(String(describing: currentlocation?.coordinate.latitude))")
            print("当前进度:\(String(describing: currentlocation?.coordinate.longitude))")
            
            var region = MKCoordinateRegion.init()
            region.span = MKCoordinateSpanMake(0.1, 0.1)
            region.center = CLLocationCoordinate2DMake((currentlocation?.coordinate.latitude)!, (currentlocation?.coordinate.longitude)!)
            self.mapView.setRegion(region, animated: true)
            
            self.addUserCurrentLocationAnnotation(coord: region.center)
        }
        
        manager.stopUpdatingLocation()
    }
    //定位出错
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        SVProgressHUD.showError(withStatus: error.localizedDescription)
    }
    //授权状态改变
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            if self.locationManager.responds(to: #selector(self.locationManager.requestWhenInUseAuthorization)) {
                self.locationManager.requestWhenInUseAuthorization()
            }
        default: break
            
        }
    }
}

//MKMapViewDelegate
extension GeofenceViewController:MKMapViewDelegate{
    //设置电子围栏圈颜色
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKCircleRenderer.init(overlay: overlay)
        render.fillColor = UIColor.init(hex: 0xf75108, alpha: 0.3)
        return render
    }
    //自定义大头针
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: KMAnnotation.self) {
            let key1 = "AnnotationKey"
            var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: key1)
            if annotationView == nil {
                annotationView = MKAnnotationView.init(annotation: annotation, reuseIdentifier: key1)
                annotationView?.canShowCallout = true
            }
            annotationView?.annotation = annotation
            annotationView?.isSelected = true
            annotationView?.image = (annotation as! KMAnnotation).image
            return annotationView
        }
        return nil
    }
    
}

extension GeofenceViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.placeMarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Subtitle")
        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "Subtitle")
        }
        let mapItem = self.placeMarks[indexPath.row]
        var address:String = ""
        if mapItem.placemark.locality != nil {
            address += mapItem.placemark.locality!
        }
        if mapItem.placemark.subLocality != nil {
            address += mapItem.placemark.subLocality!
        }
        if mapItem.placemark.thoroughfare != nil {
            address += mapItem.placemark.thoroughfare!
        }
        
        if address != "" {
            cell?.textLabel?.text = address
        }else {
            cell?.textLabel?.text = mapItem.name
        }
        
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let mapitem = self.placeMarks[indexPath.row]
        let mkplaceMark = mapitem.placemark
        var region = MKCoordinateRegion.init()
        region.span = MKCoordinateSpanMake(0.1, 0.1)
        region.center = CLLocationCoordinate2DMake(mkplaceMark.coordinate.latitude, mkplaceMark.coordinate.longitude)
        self.mapView.setRegion(region, animated: true)
        self.placeTableView.isHidden = true
        self.addressString = "地址:\(mapitem.placemark.name!)"
        self.geofenceModel.longitude = mkplaceMark.coordinate.longitude
        self.geofenceModel.latitude = mkplaceMark.coordinate.latitude
        self.geofenceModel.radius = 500
        self.updateUIWithGeofenceModel(geofence: self.geofenceModel)
        
    }
}

extension GeofenceViewController:UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let region = self.mapView.region
        let localSearchRequest = MKLocalSearchRequest.init()
        localSearchRequest.region = region
        localSearchRequest.naturalLanguageQuery = searchBar.text
        let localSearch = MKLocalSearch.init(request: localSearchRequest)
        localSearch.start { (response, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }else{
                if response?.mapItems != nil {
                    self.placeMarks = (response?.mapItems)!
                }
                self.placeTableView.isHidden = (self.placeMarks.count == 0)
                let height = self.placeMarks.count * 50
                if height < 200 {
                    self.placeTableView.snp.updateConstraints({ (make) in
                        make.height.equalTo(height)
                    })
                }else{
                    self.placeTableView.snp.updateConstraints({ (make) in
                        make.height.equalTo(200)
                    })
                }
                
                self.placeTableView.reloadData()
            }
        }
    }
}
