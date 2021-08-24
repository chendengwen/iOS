//
//  DeviceManageVC.swift
//  YiYangCloud
//
//  Created by zhong on 2017/4/24.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
import DGElasticPullToRefresh

class DeviceManageVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var healthBtn: UIButton!
    @IBOutlet weak var deviceBtn: UIButton!
    @IBOutlet weak var scrollView: UIView!
    
    var wearDataModel:WearDataModel?
    
    var type:String?
    
    
    var flag:Int = 0
    let manager = BabyBluetooth.init()
    let analysisDataTool = KMAnalysisDataTool.share()
    let macDic = NSMutableDictionary.init()
    lazy var dataArray:[String] = {
        var array = [String]()
        array.append("血压计")
        array.append("体温计")
        array.append("血糖仪")
        return array
        }()
    
    lazy var dataDic:[String:BluetoothDeviceModel] = {
        var dic = [String:BluetoothDeviceModel]()
        dic["血压计"] = self.getNormalModel(name:"血压计")
        dic["体温计"] = self.getNormalModel(name:"体温计")
        dic["血糖仪"] = self.getNormalModel(name:"血糖仪")
        return dic
    }()
    
    var oldArray = [BluetoothDeviceModel]()

    lazy var format:DateFormatter = {
        let format = DateFormatter.init()
        format.dateFormat = "YYYY-MM-dd HH:mm:ss"
        return format
    }()
    
    lazy var deviceTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60
        tableView.showsVerticalScrollIndicator = false
        tableView.frame = CGRect.init(x: 0, y: 30, width: SCREENWIDTH, height: SCREENHEIGHT - 167)
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.white
        tableView.dg_addPullToRefreshWithActionHandler({
            [unowned self]
            () -> Void in
            //网络请求刷新数据
            self.requestWearData()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red:0.35, green:0.49, blue:0.94, alpha:1.00))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        return tableView
    }()
    
    lazy var BluetoothTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60
        tableView.showsVerticalScrollIndicator = false
        tableView.frame = CGRect.init(x: 0, y: 30, width: SCREENWIDTH, height: SCREENHEIGHT - 167)
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.white
        tableView.dg_addPullToRefreshWithActionHandler({
            [unowned self]
            () -> Void in
            self.type = nil
            self.scanBluetoothDevice()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self.BluetoothTableView.dg_stopLoading()
            })
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red:0.35, green:0.49, blue:0.94, alpha:1.00))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupBluetoothDelegate()
        //automaticallyadjustsScrollviewInsets
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.scanBluetoothDevice()
        self.requestWearData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.manager
            .cancelScan()
        self.manager.cancelAllPeripheralsConnection()
        //保存蓝牙MAC地址
        UserDefaults.standard.setValue(self.dataDic["血压计"]?.UUID , forKey: "血压计")
        UserDefaults.standard.setValue(self.dataDic["血糖仪"]?.UUID , forKey: "血糖仪")
        UserDefaults.standard.setValue(self.dataDic["体温计"]?.UUID , forKey: "体温计")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didClickDeviceBtn(_ sender: UIButton) {
        self.collectionView.scrollToItem(at: IndexPath.init(item: sender.tag, section: 0), at: .centeredHorizontally, animated: true)
//        Animation(sender.tag)
    }
    @IBAction func didClickAdd(_ sender: UIBarButtonItem) {
        //穿戴设备
        let storyboard = UIStoryboard.init(name: "AddWear", bundle: nil)
        self.navigationController?.pushViewController(storyboard.instantiateViewController(withIdentifier: "AddWear"), animated: true)
    }
    
}

//Action
extension DeviceManageVC{
    fileprivate func Animation (_ tag:Int){
        let centerX = tag == 0 ? self.healthBtn.centerX : self.deviceBtn.centerX
        self.flag = tag
        UIView.animate(withDuration: 0.5, animations: {
            self.scrollView.centerX = centerX
        })
    }
    
    func scanBluetoothDevice(){
        self.manager
            .cancelScan()
        self.manager.cancelAllPeripheralsConnection()
        self.manager.scanForPeripherals().enjoy();
    }
    
    func setupBluetoothDelegate() {
        
        self.manager.setBlockOnCentralManagerDidUpdateState { (central) in
            if central?.state != .poweredOn {
                SVProgressHUD.showInfo(withStatus: "设备打开失败，请检查蓝牙功能是否打开")
            }
        }
//        //2
//        self.manager?.setFilterOnConnectToPeripherals({ (name, adv, RSSI) -> Bool in
//            return (self.analysisDataTool?.filter(onDiscoverName: name))!
//        })
//        //4
//        self.manager?.setBlockOnConnected({ (central, peripheral) in
//            print("设备: 连接成功" + (peripheral?.name)!)
//        })
        
        //3
        self.manager.setBlockOnDiscoverToPeripherals { (central, peripheral, advertisementData, RSSI) in
            //self.macDic[peripheral!] == nil && self.checkUUID(uuid: (peripheral?.identifier.description)!)
            print("搜索到设备:" + (peripheral?.name)!)
            let name = self.analysisDataTool?.getDeviceType(peripheral?.name)
            if (self.type == nil || self.type == name) {
                let model = BluetoothDeviceModel.init()
                model.deviceName = name
                model.deviceIcon = (self.analysisDataTool?.getDeviceImg(model.deviceName))!
                model.MAC = self.analysisDataTool?.getBuletoothFlaseMAC(peripheral?.identifier.description)
                model.type = peripheral?.name?.trimmingCharacters(in: NSCharacterSet.whitespaces)
                model.UUID = peripheral?.identifier.description;
                model.time = self.format.string(from: Date.init())
                if (model.deviceName != nil) {
                    self.macDic[peripheral!] = peripheral?.identifier.description;
                    
                    self.dataDic[name!] = model
                    //刷新
                    self.BluetoothTableView.reloadData()
                }
            }
        }
        //1
        self.manager.setFilterOnDiscoverPeripherals {
            [unowned self]
            (peripheralName, advertisementData, RSSI) -> Bool in
            return (self.analysisDataTool?.filter(onDiscoverName: peripheralName))!
        }
    }

    func checkUUID(uuid:String) -> Bool {
        for model:BluetoothDeviceModel in self.oldArray {
            if uuid == model.UUID {
                return false
            }
        }
        return true
    }
    
    func getNormalModel(name:String) -> BluetoothDeviceModel {
        let model = BluetoothDeviceModel.init()
        model.deviceName = name
        model.deviceIcon = (self.analysisDataTool?.getDeviceImg(model.deviceName))!
        let UUID = UserDefaults.standard.string(forKey: name)
        model.MAC = "--:--:--:--:--:--"
        if UUID != nil && (UUID?.characters.count)! > 34 {
            model.MAC = self.analysisDataTool?.getBuletoothFlaseMAC(UUID)
            model.UUID = UUID
        }
        return model
    }
}

// UI
extension DeviceManageVC{
    func setupUI() {
        self.flowLayout.itemSize = CGSize.init(width: CGFloat(SCREENWIDTH), height: SCREENHEIGHT - 108)
        self.flowLayout.minimumInteritemSpacing = 0
        self.flowLayout.minimumLineSpacing = 0
        self.flowLayout.scrollDirection = .horizontal
        self.collectionView.isPagingEnabled = true
        self.collectionView.bounces = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionViewCell")
        
        self.deviceTableView.register(DeviceCell.self, forCellReuseIdentifier: "deviceCell")
        self.BluetoothTableView.register(BluetoothCell.self, forCellReuseIdentifier: "BluetoothCell")
        
        self.scrollView.frame(forAlignmentRect: CGRect.init(x: 0, y: 38, width: self.healthBtn.width * 0.5, height: 2))
        self.scrollView.centerX = self.healthBtn.centerX;
    }
}

// MARK: - UITableViewDataSource,UITableViewDelegate
extension DeviceManageVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isEqual(self.BluetoothTableView) {
//            return self.dataArray.count
            return 3
        }else {
//            if self.wearDataModel?.content?.device == nil {
//                return 0;
//            }
//            return (self.wearDataModel?.content?.device.count)!
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell?
        if tableView.isEqual(self.deviceTableView){
            cell = tableView.dequeueReusableCell(withIdentifier: "deviceCell", for: indexPath) as! DeviceCell
            (cell as! DeviceCell).delegate = self
            
//            let model:WearDataDevice? = self.wearDataModel?.content?.device[indexPath.row]
//            (cell as! DeviceCell).model = model
            
        }else {
            cell = tableView.dequeueReusableCell(withIdentifier: "BluetoothCell", for: indexPath)
            (cell as! BluetoothCell).model = self.dataDic[self.dataArray[indexPath.row]]
            (cell as! BluetoothCell).delegate = self
        }

        return cell!
    }
}

extension DeviceManageVC: UICollectionViewDataSource,UICollectionViewDelegate{
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath)
        
        if indexPath.item == 0 {
            cell.contentView.addSubview(self.BluetoothTableView)
        }else {
            cell.contentView.addSubview(self.deviceTableView)
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isEqual(self.collectionView){
            let offsetx = scrollView.contentOffset.x
            let currentPage = Int (offsetx / SCREENWIDTH + 0.5)
            Animation(currentPage)
        }
    }

}

extension DeviceManageVC :DeviceCellDelegate,BluetoothCellDelegate {
    func pushMaintainVC(cell: DeviceCell) {
        let storyboard = UIStoryboard.init(name: "Maintain", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "Maintain") as! MaintainViewController

//        DispatchQueue.main.asyncAfter(deadline:  DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { 
//            
//        }
        VC.model = cell.model
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    
    func refreshBluetooth(type: String) {
        self.type = type
        self.scanBluetoothDevice()
    }
}

extension DeviceManageVC{
    func requestWearData(){
        KMNetWork.fetchData(urlStrig: "http://10.2.20.243:7100/app/member/getBindDevice/15361413034", success: {
            [unowned self]
            (json) in
            let model = WearDataModel.model(withJSON: json!)
            self.wearDataModel = model
            self.deviceTableView.reloadData()
            self.deviceTableView.dg_stopLoading()
            
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
            self.deviceTableView.dg_stopLoading()
        }
    }
}
