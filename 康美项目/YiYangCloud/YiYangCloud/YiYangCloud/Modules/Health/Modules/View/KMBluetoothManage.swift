//
//  KMBluetoothManage.swift
//  YiYangCloud
//
//  Created by 钟晓跃 on 2017/5/9.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol KMBluetoothManageDelegate: class {
    func showDataPage(model: NSObject)
    
    func updataInfoTitle(title: String)
}

class KMBluetoothManage: NSObject {
    
    lazy var format:DateFormatter = {
        let format = DateFormatter.init()
        format.dateFormat = "YYYY-MM-dd HH:mm:ss"
        return format
    }()
    
    var manager:BabyBluetooth? = BabyBluetooth.init()
    
    let analysisDataTool = KMAnalysisDataTool.share()
    
    var type:String?
    
    var BPmodel:BPValueModel? = nil
    
    var BSmodel:BSValueModel? = nil
    
    var isShow:Bool = false
    
    var write:CBCharacteristic?
    
    static let shared = KMBluetoothManage()
    
    weak var delegate: KMBluetoothManageDelegate?
    
    var UUID:String?
    
    private override init() {
    }
    
}

//Action
extension KMBluetoothManage{
    
    func reset(){
        self.BPmodel = nil
        self.BSmodel = nil
        self.isShow = false
        self.UUID = nil
    }
    
    func startScan(type:String){
        self.reset()
        self.type = type
        self.UUID = UserDefaults.standard.string(forKey: type)
        self.setupBluetoothDelegate()
        self.manager?.cancelScan()
        self.manager?.cancelAllPeripheralsConnection()
        self.manager?.scanForPeripherals().enjoy();
    }
    
    func stopScan(){
        self.manager?.cancelScan()
        self.manager?.cancelAllPeripheralsConnection()
    }
    
    func setupBluetoothDelegate() {
        
        self.manager?.setBlockOnCentralManagerDidUpdateState { (central) in
            if central?.state != .poweredOn {
                SVProgressHUD.showInfo(withStatus: "蓝牙启动失败，请检查手机蓝牙功能是否打开")
            }
        }
        //1
        self.manager?.setFilterOnDiscoverPeripherals {
            [unowned self]
            (peripheralName, advertisementData, RSSI) -> Bool in
            
            return (self.analysisDataTool?.checkDeviceName(peripheralName, forKey: self.type))!
        }
        //2 判断 -> 链接 将这个Block放入3
        self.manager?.setFilterOnConnectToPeripherals({
            [unowned self]
            (name, adv, RSSI) -> Bool in
            if name == nil{
                return false
            }
//            if self.UUID != nil && self.UUID != name?.identifier.description {
//                return false
//            }
//            return (self.analysisDataTool?.checkDeviceName(name?.name, forKey: self.type))!
            return true
        })
        //3
        self.manager?.setBlockOnDiscoverToPeripherals { (central, peripheral, advertisementData, RSSI) in
            print("搜索到设备:" + (peripheral?.name)!)
        }
        //4
        self.manager?.setBlockOnConnected({ (central, peripheral) in
            print("设备: 连接成功" + (peripheral?.name)!)
            self.delegate?.updataInfoTitle(title: "设备连接成功,等待数据产生.请开始测量")
        })
        //5发现服务
        self.manager?.setBlockOnDiscoverServices({ (peripheral, error) in
        })
        //6.发现特征
        self.manager?.setBlockOnDiscoverCharacteristics({
            [unowned self]
            (peripheral, service, error) in
            for characteristic in (service?.characteristics)!{
                if characteristic.uuid.uuidString == "FFE9"{
                    self.write = characteristic
                }
                
                if (self.analysisDataTool?.isNotifi(for: characteristic))!{
                    peripheral?.setNotifyValue(true, for: characteristic)
                }
                
            }
        })
        //7.读取特征
        self.manager?.setBlockOnReadValueForCharacteristic({
            [unowned self]
            (peripheral, characteristic, error) in
            if (self.type == "体温计"){
                if characteristic?.uuid.uuidString == "FFE4" {
                    let model = self.analysisDataTool?.getTemperature(characteristic?.value)
                    if model?.value != 0 {
                        self.delegate?.showDataPage(model: model!)
                    }
                }else if characteristic?.uuid.uuidString == "0200706D" {
                    let model = self.analysisDataTool?.getTemperature_BLETemp(characteristic?.value)
                    if model?.value != 0 {
                        self.delegate?.showDataPage(model: model!)
                    }
                }
            }else if (self.type == "血压计" && self.BPmodel == nil){
                if characteristic?.uuid.uuidString == "FFF4" && characteristic?.value != nil {
                    let data:NSData = (characteristic?.value!)! as NSData
                    print(data.description)
                    if (data.description.lengthOfBytes(using:.utf8) == 33) {
                        self.analysisDataTool?.show(data as Data!, type: 0)
                    }else if (data.description.lengthOfBytes(using:.utf8) == 17){
                        self.analysisDataTool?.show(data as Data!, type: 1)
                    }
                    if (data.description.hasPrefix("<fdfd")) && data.length == 13{
                        //AES-XY 血压计
                        self.BPmodel = self.analysisDataTool?.getBloodPressure(forAES_XY: characteristic?.value)
                    }else if (data.description.hasPrefix("<fffe08")) {
                        self.BPmodel = self.analysisDataTool?.getBloodPressure(forBP826: characteristic?.value)
                    }
                    if self.BPmodel != nil && self.BPmodel?.errorStr == nil{
                         self.delegate?.showDataPage(model: self.BPmodel!)
                    }
                }
            }else if (self.type == "血糖仪" && characteristic?.value != nil){
                let data:NSData = (characteristic?.value!)! as NSData
                if characteristic?.uuid.uuidString == "FFE4" {
                    self.BSmodel = self.analysisDataTool?.getBloodSugar(characteristic?.value, withCurrPeripheral: peripheral, withWrite: self.write, withOldBloodSugarModel: self.BSmodel)
                    if self.BSmodel?.value != -1 && !self.isShow{
                        self.isShow = true
                        self.delegate?.showDataPage(model: self.BSmodel!)
                    }
                    
                }else if characteristic?.uuid.uuidString == "2A18" && (data.description.hasPrefix("<87") || data.description.hasPrefix("<47") || data.description.hasPrefix("<07")){
                    self.BSmodel = self.analysisDataTool?.getBloodSugar_Glucose(characteristic?.value)
                    self.delegate?.showDataPage(model: self.BSmodel!)
                }
            }
        })
        //8.连接失败
        self.manager?.setBlockOnFailToConnect({ (central, peripheral, error) in
            self.delegate?.updataInfoTitle(title: "连接失败,请检查蓝牙设备是否打开")
        })
        //9.断开连接
        self.manager?.setBlockOnDisconnect({ (central, peripheral, error) in
            self.delegate?.updataInfoTitle(title: "设备已断开连接,请点击开始测量")
        })
    }
}
