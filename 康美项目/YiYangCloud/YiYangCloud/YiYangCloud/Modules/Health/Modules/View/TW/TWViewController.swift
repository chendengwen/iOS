//
//  TWViewController.swift
//  YiYangCloud
//
//  Created by gary on 2017/4/21.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import SVProgressHUD

class TWViewController: UIViewController {
    
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var normalView: UIView!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var InputText: UITextField!
    @IBOutlet weak var cycleGraphicsView: KMCycleGraphicsView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    
    var timer:Timer?

    lazy var format:DateFormatter = {
        let format = DateFormatter.init()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return format
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        
        if !UserDefaults.standard.bool(forKey: "isNoReminder") {
            SRAlertView.sr_show(withTitle: "温馨提示", message: "您没有绑定测量设备,现在帮助完成设置吗?", leftBtnTitle: "设备管理", rightBtnTitle: "下次再说", animationStyle: .downToCenterSpring, delegate: self,tis: true)
        }
        self.beginCheck(nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "体温"
        self.InputText.delegate = self
        
        //适配5s
        if IS_IPHONE_5 {
            self.startBtn.snp.updateConstraints({ (make) in
                make.top.equalTo(self.cycleGraphicsView.snp.bottom).offset(75)
            })
        }
    }
    
    //MARK: 开始测量
    @IBAction func beginCheck(_ sender: Any?) {
        KMBluetoothManage.shared.startScan(type: "体温计")
        KMBluetoothManage.shared.delegate = self
        self.infoBtn.setTitle("正在扫描蓝牙设备", for: .normal)
        self.timer = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(self.showAlertView), userInfo: nil, repeats: false)
    }
    
    //MARK: 重新测量
    @IBAction func didClickRemeasureBtn(_ sender: UIButton) {
        self.cycleGraphicsView.reset()
        self.normalView.isHidden = false

    }
    //MARK: 手动输入
    @IBAction func didClickInputBtn(_ sender: UIButton) {
        let value = CGFloat(Float(self.InputText.text!)!)
        let model = temperatureValueModel.init()
        model.value = value
        
        self.show(model:model)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        KMBluetoothManage.shared.stopScan()
    }
}

extension TWViewController: SRAlertViewDelegate{

    func alertViewDidClick(_ btnType: AlertViewBtnType) {
        if btnType == .left {
            if self.normalView.isHidden {
                //创建档案
                self.tabBarController?.selectedIndex = 1;
            }else{
                //添加设备
                self.tabBarController?.selectedIndex = 2;
                self.navigationController?.popViewController(animated: false)
            }
            
        }
    }
}

extension TWViewController{
    
    func showAlertView(){
        let alertAction = UIAlertAction.init(title: "确定", style: .default, handler: nil)
        let alertController = UIAlertController.init(title: "系统提示", message: "未能扫描到蓝牙设备,\n请确认蓝牙设备是否打开!", preferredStyle: .alert)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getColor(value:CGFloat) -> UIColor{

        if value >= 40.0 {
            self.resultLabel.text = "重度发烧"
            return UIColor.red
        }
        if value >= 39.0 {
            self.resultLabel.text = "重度发烧"
            return UIColor.red
        }
        if value >= 38.0 {
            self.resultLabel.text = "中度发烧"
            return UIColor.orange
        }
        if value >= 37.5 {
            self.resultLabel.text = "轻微发烧"
            return UIColor.yellow
        }
        if value >= 36.0 {
            self.resultLabel.text = "正常体温"
            return UIColor(hex:0x7FC156)
        }
        if value >= 0.0  {
            self.resultLabel.text = "体温过低"
            return UIColor(hex:0x4396FF)
        }
        return UIColor.green
    }
}

extension TWViewController{
    //展示页面
    func show(model:temperatureValueModel){
        let color = getColor(value:model.value)
        self.resultLabel.textColor = color
        self.cycleGraphicsView.reloadGraphics(color, maxValue: 43, totalValue: model.value)
        self.normalView.isHidden = true
        self.view.endEditing(true)
        SRAlertView.sr_show(withTitle: "温馨提示", message: "量测成功,帮助长期管理个人健康建立个人健康档案吗?", leftBtnTitle: "创建档案", rightBtnTitle: "下次再说", animationStyle: .downToCenterSpring, delegate: self)
        
        uploadData(model:model)
    }
    //数据上传
    func uploadData(model:temperatureValueModel){
        //temperature:  memberId   tempTime   tempUnit   temp
        let parameters = [
            "memberId":"3315",
            "tempTime":self.format.string(from: Date.init()),
            "tempUnit":"0",
            "temp":"\(model.value)"]
        
        KMNetWork.fetchDataPost(urlStrig: "http://\(ServerAddress)/app/member/healthRange/temperature", parameters: parameters, success: { (data) in
//            SVProgressHUD.showSuccess(withStatus: "数据上传成功")
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
        
    }
}

extension TWViewController:KMBluetoothManageDelegate{
    func showDataPage(model: NSObject) {
        let Tmodel = model as! temperatureValueModel
        self.show(model: Tmodel)
    }
    
    func updataInfoTitle(title: String) {
        if title == "设备连接成功,等待数据产生.请开始测量" {
            self.timer?.invalidate()
            self.timer = nil
        }
        self.infoBtn.setTitle(title, for: .normal)
    }
}

extension TWViewController:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return TextCheckManage.share().checkTextDecimalText(textField, andRange: range, andString: string)
    }
}
