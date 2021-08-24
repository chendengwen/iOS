//
//  XYViewController.swift
//  YiYangCloud
//
//  Created by gary on 2017/4/21.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import SVProgressHUD

class XYViewController: UIViewController {

    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var normalView: UIView!
    @IBOutlet weak var cycleGraphicsView_L: KMCycleGraphicsView!
    
    @IBOutlet weak var cycleGraphicsView_H: KMCycleGraphicsView!
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var infoBtn: UIButton!
    
    lazy var rangeModel:BPRangeModel = {
        var rangeModel = BPRangeModel.init()
        rangeModel.content = BPRangeModelContent.init()
        return rangeModel
    }()
    
    var timer:Timer?
    
    lazy var format:DateFormatter = {
        let format = DateFormatter.init()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return format
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "血压测量"
        
        //适配5s
        if IS_IPHONE_5 {
            self.startBtn.snp.updateConstraints({ (make) in
                make.top.equalTo(self.cycleGraphicsView_L.snp.bottom).offset(100)
            })
        }
    
        self.rangeModel.content?.bpdL = "60"
        self.rangeModel.content?.bpdH = "89"
        self.rangeModel.content?.bpsL = "90"
        self.rangeModel.content?.bpsH = "139"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let UUID = UserDefaults.standard.string(forKey: "血压计")
        
        if UUID == nil && !UserDefaults.standard.bool(forKey: "isNoReminder"){
            SRAlertView.sr_show(withTitle: "温馨提示", message: "您没有绑定测量设备,现在帮助完成设置吗?", leftBtnTitle: "设备管理", rightBtnTitle: "下次再说", animationStyle: .downToCenterSpring, delegate: self,tis: true)
        }
        self.beginCheck(nil)
    }
    
    //MARK: 开始测量
    @IBAction func beginCheck(_ sender: Any?) {
        KMBluetoothManage.shared.startScan(type: "血压计")
        KMBluetoothManage.shared.delegate = self
        self.infoBtn.setTitle("正在扫描蓝牙设备", for: .normal)

        self.timer = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(self.showAlertView), userInfo: nil, repeats: false)
    }
    
    
    @IBAction func didClickReset(_ sender: UIButton) {
        KMBluetoothManage.shared.reset()
        cycleGraphicsView_L.reset()
        cycleGraphicsView_H.reset()
        self.normalView.isHidden = false
    }
    //MARK: 手动输入
    @IBAction func manualTyping(_ sender: Any) {
        let inputBox:InputBox = Bundle.main.loadNibNamed("InputBox", owner: nil, options: nil)?.last as! InputBox
        inputBox.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT + 98)
        inputBox.delegate = self
        self.view.addSubview(inputBox)
        UIView.animate(withDuration: 0.33) {
            inputBox.frame = CGRect.init(x: 0, y: -162, width: SCREENWIDTH, height: SCREENHEIGHT + 98)
            inputBox.backgroundColor? = UIColor.init(hex: 0x000000, alpha: 0.6)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        KMBluetoothManage.shared.stopScan()
    }

}

extension XYViewController:InputBoxDelegate{
    
    func showAlertView(){
        let alertAction = UIAlertAction.init(title: "确定", style: .default, handler: nil)
        let alertController = UIAlertController.init(title: "系统提示", message: "未能扫描到蓝牙设备,\n请确认蓝牙设备是否打开!", preferredStyle: .alert)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getXYModel(model: BPValueModel) {
        
        if model.hbp > 159 || model.lbp > 94 {
            self.resultLabel.text = "高血压"
            self.resultLabel.textColor = UIColor.red
        }else if model.hbp > 139 || model.lbp > 89 {
            self.resultLabel.text = "血压偏高"
            self.resultLabel.textColor = UIColor.orange
        }else if model.hbp > Int32((self.rangeModel.content?.bpsL)!)!   || model.lbp > Int32((self.rangeModel.content?.bpdL)!)!  {
            self.resultLabel.text = "血压正常"
            self.resultLabel.textColor = UIColor(hex:0x7FC156)
        }else if model.hbp > 49  || model.lbp > 29 {
            self.resultLabel.text = "血压偏低"
            self.resultLabel.textColor = UIColor(hex:0x4396FF)
        }
        
        self.resultLabel.textColor = getColor(type: 0, value: Int(model.lbp))
        cycleGraphicsView_L.reloadGraphics(getColor(type: 0, value: Int(model.lbp)), maxValue:110, totalValue: CGFloat(model.lbp))
        cycleGraphicsView_H.reloadGraphics(getColor(type: 1, value: Int(model.hbp)), maxValue:180, totalValue: CGFloat(model.hbp))
        self.normalView.isHidden = true
        //判断是否有档案 提示创建
        SRAlertView.sr_show(withTitle: "温馨提示", message: "量测成功,帮助长期管理个人健康建立个人健康档案吗?", leftBtnTitle: "创建档案", rightBtnTitle: "下次再说", animationStyle: .downToCenterSpring, delegate: self)
        //数据上传
        uploadData(model:model)
    }
    
    func getColor(type:Int ,value:Int) -> UIColor{
        if type == 1 {
            //收缩压
            if value > 159 {return UIColor.red}
            if value > Int((self.rangeModel.content?.bpsH)!)!  {return UIColor.orange}
            if value > Int((self.rangeModel.content?.bpsL)!)!  {return UIColor(hex:0x7FC156)}
            if value > 49 {return UIColor(hex:0x4396FF)}
        }else if type == 0 {
            //舒张压
            if value > 94 {return UIColor.red}
            if value > Int((self.rangeModel.content?.bpdH)!)! {return UIColor.orange}
            if value > Int((self.rangeModel.content?.bpdL)!)! {return UIColor(hex:0x7FC156)}
            if value > 29 {return UIColor(hex:0x4396FF)}
        }
        return UIColor(hex:0x7FC156)
    }
    
}


// MARK: - SRAlertViewDelegate
extension XYViewController:SRAlertViewDelegate{
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

//数据上传
extension XYViewController{

    func uploadData(model:BPValueModel){
        
        let parameters = [
            "memberId":"3315",
            "bpTime":self.format.string(from: Date.init()),
            "hPressure":"\(model.hbp)",
            "lPressure":"\(model.lbp)",
            "puls":"\(model.heartRate)"]
        
        KMNetWork.fetchDataPost(urlStrig: "http://\(ServerAddress)/app/member/healthRange/bp", parameters: parameters, success: { (data) in
//            SVProgressHUD.showSuccess(withStatus: "数据上传成功")
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
    }
    
    func getBPRange(){
        KMNetWork.fetchData(urlStrig: "http://10.2.20.243:7000/app/member/getMemberLimit/3315/bp", success: {
            [unowned self]
            (json) in
            self.rangeModel = BPRangeModel.model(withJSON: json!)!
            
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
    }
}


// MARK: - KMBluetoothManageDelegate
extension XYViewController:KMBluetoothManageDelegate{
    func showDataPage(model: NSObject) {
        let BPmodel = model as! BPValueModel
        self.getXYModel(model: BPmodel)
    }
    
    func updataInfoTitle(title: String) {
        if title == "设备连接成功,等待数据产生.请开始测量" {
            self.timer?.invalidate()
            self.timer = nil
        }
        self.infoBtn.setTitle(title, for: .normal)
    }
}
