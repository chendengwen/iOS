//
//  XTViewController.swift
//  YiYangCloud
//
//  Created by gary on 2017/4/21.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import SVProgressHUD

class XTViewController: UIViewController {
    
    @IBOutlet weak var cycleGraphicsView: KMCycleGraphicsView!
    @IBOutlet weak var InputText: UITextField!
    @IBOutlet weak var normalView: UIView!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var suijiBtn: UIButton!
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var resultLab: UILabel!
    
    @IBOutlet weak var lastTime: UILabel!
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    var selectBtnTag:Int = 0
    var value:Int32? = -1
    
    var timer:Timer?
    
    lazy var rangeModel:BSRangeModel = {
        var rangeModel = BSRangeModel.init()
        rangeModel.content = BSRangeModelContent.init()
        return rangeModel
    }()
    
    lazy var format:DateFormatter = {
        let format = DateFormatter.init()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return format
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        //适配5s
        if IS_IPHONE_5 {
            
            self.infoBtn.snp.updateConstraints({ (make) in
                make.top.equalTo(self.normalView).offset(20)
            })
            
            self.cycleGraphicsView.snp.updateConstraints({ (make) in
                make.top.equalTo(self.infoBtn).offset(25)
            })
            self.startBtn.snp.updateConstraints({ (make) in
                make.top.equalTo(self.cycleGraphicsView.snp.bottom).offset(75)
            })
        }
        
        self.rangeModel.content?.afterMealH = "200"
        self.rangeModel.content?.afterMealL = "140"
        self.rangeModel.content?.beforeBedH = "124"
        self.rangeModel.content?.beforeBedL = "72"
        self.rangeModel.content?.beforeMealH = "124"
        self.rangeModel.content?.beforeMealL = "72"
        self.rangeModel.content?.dinnerT = "17:00-19:00"
        self.rangeModel.content?.lunchT = "11:00-13:00"
        self.getBSRange()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if !UserDefaults.standard.bool(forKey: "isNoReminder") {
            SRAlertView.sr_show(withTitle: "温馨提示", message: "您没有绑定测量设备,现在帮助完成设置吗?", leftBtnTitle: "设备管理", rightBtnTitle: "下次再说", animationStyle: .downToCenterSpring, delegate: self,tis: true)
        }
        self.didClickStartBtn(nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didClickChangeType(_ sender: UIButton) {
        //切换血糖类型
        self.selectBtnTag = sender.tag
        Animation(sender.centerX)
        //刷新数据
        if self.value != -1 {
            self.cycleGraphicsView.reset()
            let color = getColor(value: self.value!)
            self.resultLab.textColor = color
            self.cycleGraphicsView.reloadGraphics(color, maxValue: 605, totalValue: CGFloat(self.value!))
        }
    }
    
    //手动输入
    @IBAction func didClickInputBtn(_ sender: UIButton) {
        let model = BSValueModel.init()
        let value:NSString = self.InputText.text! as NSString
        model.value = value.intValue
        self.show(model:model)
    }
    
    //开始测量
    @IBAction func didClickStartBtn(_ sender: Any?) {
        KMBluetoothManage.shared.startScan(type: "血糖仪")
        KMBluetoothManage.shared.delegate = self
        self.infoBtn.setTitle("正在扫描蓝牙设备", for: .normal)
        self.timer = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(self.showAlertView), userInfo: nil, repeats: false)
    }
    //重新测量
    @IBAction func didClickRemeasureBtn(_ sender: UIButton) {
        KMBluetoothManage.shared.reset()
        self.cycleGraphicsView.reset()
        self.normalView.isHidden = false
    }
    
    deinit {
        KMBluetoothManage.shared.stopScan()
    }
}

//Action
extension XTViewController{
    func showAlertView(){
        let alertAction = UIAlertAction.init(title: "确定", style: .default, handler: nil)
        let alertController = UIAlertController.init(title: "系统提示", message: "未能扫描到蓝牙设备,\n请确认蓝牙设备是否打开!", preferredStyle: .alert)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func Animation (_ centerX:CGFloat){
        UIView.animate(withDuration: 0.5, animations: {
            self.scrollView.centerX = centerX
        })
    }
    
    func getColor(value:Int32) -> UIColor{
        switch self.selectBtnTag {
        case 0:
            if value >  Int32(33.3 * 18.1){
                self.resultLab.text = "Hi"
                return UIColor.red
            }
            //Int32(11.1 * 18.1)
            if value >= Int32((self.rangeModel.content?.beforeBedH!)!)!    {
                self.resultLab.text = "血糖偏高"
                return UIColor.orange
            }
            //Int32(1.1 * 18.1)
            if value >= Int32((self.rangeModel.content?.beforeBedL!)!)!     {
                self.resultLab.text = "血糖正常"
                return UIColor(hex:0x7FC156)
            }
            if value >= 0       {
                self.resultLab.text = "血糖偏低"
                return UIColor(hex:0x4396FF)
            }
        case 1:
            if value >  Int32(33.3 * 18.1)    {
                self.resultLab.text = "Hi"
                return UIColor.red
            }
            //Int32(6.1 * 18.1)
            if value >  Int32((self.rangeModel.content?.beforeMealH)! )!     {
                self.resultLab.text = "血糖偏高"
                return UIColor.orange
            }
            //Int32(3.9 * 18.1)
            if value >= Int32((self.rangeModel.content?.beforeMealL)!)!       {
                self.resultLab.text = "血糖正常"
                return UIColor(hex:0x7FC156)
            }
            if value >= Int32(1.1 * 18.1)     {
                self.resultLab.text = "血糖偏低"
                return UIColor(hex:0x4396FF)
            }
            if value >= 0       {
                self.resultLab.text = "Lo"
                return UIColor.yellow
            }
        case 2:
            if value >  Int32(33.3 * 18.1)    {
                self.resultLab.text = "Hi"
                return UIColor.red
            }
            //Int32(7.8 * 18.1)
            if value >= Int32((self.rangeModel.content?.afterMealH)!)!     {
                self.resultLab.text = "血糖偏高"
                return UIColor.orange
            }
            //Int32(3.9 * 18.1)
            if value >= Int32((self.rangeModel.content?.afterMealL)!)!     {
                self.resultLab.text = "血糖正常"
                return UIColor(hex:0x7FC156)
            }
            if value >= Int32(1.1 * 18.1)     {
                self.resultLab.text = "血糖偏低"
                return UIColor(hex:0x4396FF)
            }
            if value >= 0       {
                self.resultLab.text = "Lo"
                return UIColor.yellow
            }
        default: break
        }
        return UIColor(hex:0x7FC156)
    }
    
}

//UI
extension XTViewController{
    func setupUI(){
        self.title = "血糖"
        self.scrollView.frame(forAlignmentRect: CGRect.init(x: 0, y: 38, width: self.suijiBtn.width * 0.5, height: 2))
        self.scrollView.centerX = self.suijiBtn.centerX;
    }
}

//Delegate
extension XTViewController: SRAlertViewDelegate{
    
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
extension XTViewController{
    func show(model:BSValueModel){
        self.value = model.value
        let color = getColor(value: self.value!)
        self.resultLab.textColor = color
        self.cycleGraphicsView.reloadGraphics(color, maxValue: 605, totalValue: CGFloat(self.value!))
        self.normalView.isHidden = true
        self.view.endEditing(true)
        SRAlertView.sr_show(withTitle: "温馨提示", message: "量测成功,帮助长期管理个人健康建立个人健康档案吗?", leftBtnTitle: "创建档案", rightBtnTitle: "下次再说", animationStyle: .downToCenterSpring, delegate: self)
        self.InputText.text = ""
        
        uploadData(model:model)
    }
    
    func uploadData(model:BSValueModel){
        //bs     :  memberId   bsTime     unit       glu
        let parameters = [
            "memberId":"3315",
            "bsTime":self.format.string(from: Date.init()),
            "unit":"\(self.selectBtnTag)",
            "glu":"\(model.value)"]
        
        KMNetWork.fetchDataPost(urlStrig: "http://\(ServerAddress)/app/member/healthRange/bs", parameters: parameters, success: { (data) in
            //            SVProgressHUD.showSuccess(withStatus: "数据上传成功")
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
    }
    
    func getBSRange(){
        KMNetWork.fetchData(urlStrig: "http://10.2.20.243:7000/app/member/getMemberLimit/3315/bs", success: {
            [unowned self]
            (json) in
            let model = BSRangeModel.model(withJSON: json!)!
            self.rangeModel = model
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
    }
}

extension XTViewController:KMBluetoothManageDelegate{
    
    func showDataPage(model: NSObject) {
        let BSmodel = model as! BSValueModel
        self.show(model: BSmodel)
    }
    
    func updataInfoTitle(title: String) {
        if title == "设备连接成功,等待数据产生.请开始测量" {
            self.timer?.invalidate()
            self.timer = nil
        }
        self.infoBtn.setTitle(title, for: .normal)
    }
}
