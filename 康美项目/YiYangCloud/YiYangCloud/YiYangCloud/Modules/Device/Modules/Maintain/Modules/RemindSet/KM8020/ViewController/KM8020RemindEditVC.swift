//
//  KM8020RemindEditVC.swift
//  YiYangCloud
//
//  Created by 钟晓跃 on 2017/5/22.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

enum KM8020RemindEditStatus{
    case KM8020RemindStatusAdd
    case KM8020RemindStatusEdit
}

class KM8020RemindEditVC: UITableViewController {
    
    let sections = ["","提醒内容","重复提醒"]
    
    let rowDic:[Int:[String]] = [0:["时间"],1:["请输入提醒内容"],2:["周一","周二","周三","周四","周五","周六","周日"]]
    
    var textField = UITextField.init()
    
    var timeSelected:CustomIOSAlertView?
    
    var datePicker:UIDatePicker?
    
    var imei:String?
    
    var status:KM8020RemindEditStatus?
    
    lazy var format:DateFormatter = {
        let format = DateFormatter.init()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        return format
    }()
    
    var model:KMRemindDetailModel?{
        didSet{
            
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView.init()
        self.tableView.rowHeight = 70
        if self.model == nil {
            self.model = getModel()
        }
        self.configNavBar()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - UI
extension KM8020RemindEditVC{
    func configNavBar(){
        self.title = "提醒内容"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.didClickSaveBtn(sender:)))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    
    func showTimeSelectedAlertView(){
        self.view.endEditing(true)
        self.timeSelected = CustomIOSAlertView.init()
        self.timeSelected?.buttonTitles = nil
        
        let view = KMCommonAlertView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH - 40, height: 240))
        view.titleLabel.text = "请选择时间"
        view.buttonsArray = ["确定","取消"]
        var btn = view.realButtons[0] as! UIButton
        btn.tag = 3001
        btn.addTarget(self, action: #selector(self.timeAlertSelectedAction(sender:)), for: .touchUpInside)
        btn = view.realButtons[1] as! UIButton
        btn.tag = 3002
        btn.addTarget(self, action: #selector(self.timeAlertSelectedAction(sender:)), for: .touchUpInside)
        
        let datePicker = UIDatePicker.init()
        view.customerView.addSubview(datePicker)
        datePicker.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.center.equalTo(view)
            make.height.equalTo(140)
        }
        datePicker.locale = Locale.current
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date.init()
        self.datePicker = datePicker
        
        self.timeSelected?.containerView = view
        self.timeSelected?.show()
    }
}


// MARK: - Action
extension KM8020RemindEditVC{
    func didClickSaveBtn(sender:UIBarButtonItem){
        self.view.endEditing(true)
        if self.status == .KM8020RemindStatusEdit{
            self.saveEditUserInfomation()
        }else{
            self.saveAddUserInfomation()
        }
    }
    
    func saveEditUserInfomation(){
        let request = String.init(format: "http://10.2.20.234:7000/app/device/addRemind/t9/%@/%@/%@", "865946021011083",(self.model?.team)!,(self.model?.type)!)
        var body:[String:Any]?
        if self.model?.type == "0" || self.model?.type == "1"{//(self.model?.remindTime)!
            body = ["remindTime":(self.model?.remindTime)!,
                    "remindText":(self.model?.remindText)!]
        }else {
            body = ["remindTime":(self.model?.remindTime)!,
                    "remindText":(self.model?.remindText)!,
                    "mon":(self.model?.mon)!,
                    "tue":(self.model?.tue)!,
                    "wed":(self.model?.wed)!,
                    "thu":(self.model?.thu)!,
                    "fri":(self.model?.fri)!,
                    "sat":(self.model?.sat)!,
                    "sun":(self.model?.sun)!]
        }
        
        KMNetWork.fetchDataPost(urlStrig: request, parameters: body!, success: {
            [unowned self]
            (json) in
            let model = KMRemindModel.model(withJSON: json!)
            if model?.errorCode == nil {
                SVProgressHUD.showSuccess(withStatus: "修改提醒以发送到手表")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                    self.navigationController?.popViewController(animated: true)
                })
                
            }else{
                SVProgressHUD.showError(withStatus: model?.msg!)
            }
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
    }
    
    func saveAddUserInfomation(){
        SVProgressHUD.show()
        let repart = String.init(format: "%@%@%@%@%@%@%@", (self.model?.mon!)!,(self.model?.tue)!,(self.model?.wed!)!,(self.model?.thu!)!,(self.model?.fri)!,(self.model?.sat!)!,(self.model?.sun!)!)
        
        var type:Int = 2
        if repart == "0000000" {
            type = 0
        }else if repart == "1111111"{
            type = 1
        }
        var body:[String:Any]?
        if (type == 0 || type == 1){
            body = ["remindTime":(self.model?.remindTime)!,
                    "remindText":(self.model?.remindText)!]
        }else{
            body = ["remindTime":(self.model?.remindTime)!,
                    "remindText":(self.model?.remindText)!,
                    "mon":(self.model?.mon)!,
                    "tue":(self.model?.tue)!,
                    "wed":(self.model?.wed)!,
                    "thu":(self.model?.thu)!,
                    "fri":(self.model?.fri)!,
                    "sat":(self.model?.sat)!,
                    "sun":(self.model?.sun)!]
        }
        
        let request = String.init(format: "http://10.2.20.234:7000/app/device/addRemind/t9/%@/%@", "865946021011083","\(type)")
        KMNetWork.fetchDataPost(urlStrig: request, parameters: body!, success: {
            [unowned self]
            (json) in
            let model = KMRemindModel.model(withJSON: json!)
            if model?.msg == "Adding Remind message send Successfully" {
                SVProgressHUD.showSuccess(withStatus: "添加提醒以发送到手表")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                    self.navigationController?.popViewController(animated: true)
                })
                
            }else{
                SVProgressHUD.showError(withStatus: model?.msg!)
            }
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
    }
    
    func getModel() -> KMRemindDetailModel {
        var model = KMRemindDetailModel.init()
        model = KMRemindDetailModel.init()
        model.mon = "0"
        model.tue = "0"
        model.wed = "0"
        model.thu = "0"
        model.fri = "0"
        model.sat = "0"
        model.sun = "0"
        model.remindText = ""
        model.remindTime = ""
        return model
    }
    
    func imageFromColor(color:UIColor) -> UIImage{
        let rect = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    func repeatRemindAction(sender:UIButton){
        sender.isSelected = !sender.isSelected
        let status = sender.isSelected ? "1" : "0"
        switch sender.tag {
        case 0:
            self.model?.mon = status
        case 1:
            self.model?.tue = status
        case 2:
            self.model?.wed = status
        case 3:
            self.model?.thu = status
        case 4:
            self.model?.fri = status
        case 5:
            self.model?.sat = status
        case 6:
            self.model?.sun = status
        default:
            break
            
        }
    }
    
    func returnButtonSelectedStatusWithIndex(row:Int) -> Bool{
        switch row {
        case 0:
            return self.model!.mon! == "1"
        case 1:
            return self.model!.tue! == "1"
        case 2:
            return self.model!.wed! == "1"
        case 3:
            return self.model!.thu! == "1"
        case 4:
            return self.model!.fri! == "1"
        case 5:
            return self.model!.sat! == "1"
        case 6:
            return self.model!.sun! == "1"
        default:
            break;
        }
        return false
    }
    
    func timeAlertSelectedAction(sender:UIButton){
        let index = sender.tag - 3000
        
        if index == 1 {
            self.model?.remindTime = self.format.string(from: (self.datePicker?.date)!)
            
            self.tableView.reloadData()
        }
        self.timeSelected?.close()
    }
    
}

// MARK: - UITableViewDataSroucc,UITableViewDelegate
extension KM8020RemindEditVC{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.status == .KM8020RemindStatusAdd || self.model?.type == "2" {
            return self.sections.count
        }
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let array = self.rowDic[section]
        
        return (array?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifer = (indexPath.section == 2 ? "section2" :"section0")
        var cell = tableView.dequeueReusableCell(withIdentifier: identifer)
        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: identifer)
        }
        
        if indexPath.section == 2 {
            cell?.textLabel?.text = self.rowDic[indexPath.section]?[indexPath.row]
            cell?.imageView?.image = self.imageFromColor(color: UIColor.clear)
            //辅助视图
            let checkButton = UIButton.init(type: .custom)
            checkButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
            checkButton.setBackgroundImage(UIImage.init(named: "set_button_choose_normal"), for: .normal)
            checkButton.setBackgroundImage(UIImage.init(named: "set_button_choose_sel"), for: .selected)
            //设置Cell
            cell?.accessoryView = checkButton
            checkButton.tag = indexPath.row
            checkButton.addTarget(self, action: #selector(self.repeatRemindAction(sender:)), for: .touchUpInside)
            if !(self.status == .KM8020RemindStatusAdd) {
                checkButton.isSelected = self.returnButtonSelectedStatusWithIndex(row: indexPath.row)
            }
        }else if (indexPath.section == 1){
            self.textField.removeFromSuperview()
            //输入视图
            cell?.contentView.addSubview(self.textField)
            self.textField.snp.makeConstraints({ (make) in
                make.top.equalTo((cell?.contentView)!).offset(0)
                make.left.equalTo((cell?.contentView)!).offset(10)
                make.right.equalTo((cell?.contentView)!).offset(-10)
                make.bottom.equalTo((cell?.contentView)!).offset(0)
            })
            
            self.textField.delegate = self
            if (self.model?.remindText?.characters.count)! > 0 {
                self.textField.text = self.model?.remindText
            }else{
                textField.placeholder = self.rowDic[indexPath.section]?[indexPath.row]
            }
        }else if (indexPath.section == 0){
            cell?.textLabel?.text = self.rowDic[indexPath.section]?[indexPath.row]
            if self.model?.remindTime != "" {
                let strDate = self.model?.remindTime!
                cell?.detailTextLabel?.text = strDate?.substring(from: (strDate?.index((strDate?.endIndex)!, offsetBy: -5))!)
            }
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && self.status == .KM8020RemindStatusAdd{
            self.showTimeSelectedAlertView()
        }
    }
}

// MARK: - UITextFieldDelegate
extension KM8020RemindEditVC:UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.model?.remindText = textField.text
    }
}
