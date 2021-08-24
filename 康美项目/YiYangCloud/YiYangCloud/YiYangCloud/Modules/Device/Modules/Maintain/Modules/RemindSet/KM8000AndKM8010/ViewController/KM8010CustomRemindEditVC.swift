//
//  KM8010CustomRemindEditVC.swift
//  YiYangCloud
//
//  Created by 钟晓跃 on 2017/5/26.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh
import SnapKit

class KM8010CustomRemindEditVC: UIViewController {

    var type:RemindType = .custom
    
    var staust:RemindStauts = .add
    
    var titleLabel:UILabel?
    var textView:UITextField?
    
    lazy var format:DateFormatter = {
        let format = DateFormatter.init()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        return format
    }()
    
    var model:KM8000_KM8010RemindList?
    
    var timeSelected:CustomIOSAlertView?
    
    var datePicker:UIDatePicker?
    
    var timeBtn:UIButton?
    
    var titleArray = ["周一","周二","周三","周四","周五","周六","周日"]
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 70
        tableView.tableFooterView = UIView.init()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNavBar()
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension KM8010CustomRemindEditVC{
    func timeAlertSelectedAction(sender:UIButton){
        let index = sender.tag - 3000
        
        if index == 1 {
            self.timeBtn?.setTitle(self.format.string(from: (self.datePicker?.date)!), for: .normal)
        }
        self.timeSelected?.close()
    }
    
    func timeSelectedAction(sender:UIButton){
        showTimeSelectedAlertView()
    }
    
    /// 保存
    func didClickSaveBtn(sender:UIButton){
        
    }
    
    func switchDidChange(sender:UISwitch){
        
    }
    
    func repeatRemindAction(sender:UIButton){
        sender.isSelected = !sender.isSelected
        let status = sender.isSelected ? "1" : "0"
        switch sender.tag {
        case 0:
            self.model?.t1Hex = status
        case 1:
            self.model?.t2Hex = status
        case 2:
            self.model?.t3Hex = status
        case 3:
            self.model?.t4Hex = status
        case 4:
            self.model?.t5Hex = status
        case 5:
            self.model?.t6Hex = status
        case 6:
            self.model?.t7Hex = status
        default:
            break
            
        }
    }
    
    func returnButtonSelectedStatusWithIndex(row:Int) -> Bool{
        switch row {
        case 0:
            return self.model!.t1Hex! == "1"
        case 1:
            return self.model!.t2Hex! == "1"
        case 2:
            return self.model!.t3Hex! == "1"
        case 3:
            return self.model!.t4Hex! == "1"
        case 4:
            return self.model!.t5Hex! == "1"
        case 5:
            return self.model!.t6Hex! == "1"
        case 6:
            return self.model!.t7Hex! == "1"
        default:
            break;
        }
        return false
    }

}

// MARK: - UI
extension KM8010CustomRemindEditVC{
    func configNavBar(){
        self.title = "自定义提醒"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.didClickSaveBtn(sender:)))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    
    func showTimeSelectedAlertView(){
        self.timeSelected = CustomIOSAlertView.init()
        self.timeSelected?.buttonTitles = nil
        
        let view = KMCommonAlertView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 240))
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
            make.height.equalTo(200)
        }
        datePicker.locale = Locale.current
        
        datePicker.datePickerMode = .dateAndTime
        
        self.datePicker = datePicker
        
        self.timeSelected?.containerView = view
        self.timeSelected?.show()
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
}

extension KM8010CustomRemindEditVC:UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}

// MARK: - UITableViewDataSource,UITableViewDelegate
extension KM8010CustomRemindEditVC:UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }else {
            return 7
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "\(indexPath.section)"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
             cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: identifier)
        }
        
        if self.staust == .edit {
            if indexPath.section == 0 && indexPath.row == 0 {
                cell?.textLabel?.text = "开关"
                let mySwitch = UISwitch.init()
                cell?.accessoryView = mySwitch
                mySwitch.isOn = (self.model?.isvalid == "Y")
                mySwitch.addTarget(self, action: #selector(self.switchDidChange(sender:)), for: .valueChanged)
            }else if (indexPath.section == 0 && indexPath.row == 1) {
                cell?.textLabel?.text = "时间"
                let timeBtn = UIButton.init()
                timeBtn.setTitleColor(UIColor.gray, for: .normal)
                timeBtn.contentHorizontalAlignment = .right
                cell?.accessoryView = timeBtn
                timeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                timeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
                timeBtn.frame = CGRect.init(x: 0, y: 0, width: 200, height: 35)
                var time  = String.init(format: "%@-%@-%@ %@:%@", (self.model?.sYear)!,(self.model?.sMon!)!,(self.model?.sDay)!,(self.model?.sHour)!,(self.model?.sMin)!)
                if time.hasPrefix("0") || time.hasPrefix("-") || time.hasPrefix("null"){
                    time = "未设置时间"
                }
                timeBtn.setTitle(time, for: .normal)
                timeBtn.addTarget(self, action: #selector(self.timeSelectedAction(sender:)), for: .touchUpInside)
                self.timeBtn = timeBtn
            }else if indexPath.section == 0 && indexPath.row == 2 {
                self.titleLabel?.removeFromSuperview()
                self.titleLabel = nil
                self.titleLabel = UILabel.init()
            
                cell?.contentView.addSubview(self.titleLabel!)
                self.titleLabel?.snp.makeConstraints({ (make) in
                    make.height.equalTo(35)
                    make.top.right.equalTo(0)
                    make.left.equalTo(15)
                })
                
                self.titleLabel?.textAlignment = .left
                self.titleLabel?.text = "提醒内容"
                
                let textField = UITextField.init()
                textField.delegate = self
                cell?.contentView.addSubview(textField)
                textField.snp.makeConstraints({ (make) in
                    make.top.equalTo((cell?.snp.centerY)!).offset(0)
                    make.left.equalTo(30)
                    make.right.equalTo(-10)
                    make.bottom.equalTo(0)
                })
                textField.text = self.model?.attribute1
                self.textView = textField
            }
            
            if indexPath.section == 1 {
                cell?.textLabel?.text = self.titleArray[indexPath.row]
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
                checkButton.isSelected = self.returnButtonSelectedStatusWithIndex(row: indexPath.row)
            }
        }else {
            if indexPath.section == 0 && indexPath.row == 0 {
                cell?.textLabel?.text = "开关"
                let mySwitch = UISwitch.init()
                cell?.accessoryView = mySwitch
                mySwitch.isOn = false
                mySwitch.addTarget(self, action: #selector(self.switchDidChange(sender:)), for: .valueChanged)
            }else if (indexPath.section == 0 && indexPath.row == 1) {
                cell?.textLabel?.text = "时间"
                let timeBtn = UIButton.init()
                timeBtn.setTitleColor(UIColor.gray, for: .normal)
                timeBtn.contentHorizontalAlignment = .right
                cell?.accessoryView = timeBtn
                timeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                timeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
                timeBtn.frame = CGRect.init(x: 0, y: 0, width: 200, height: 35)
                timeBtn.setTitle("未设置时间", for: .normal)
                timeBtn.addTarget(self, action: #selector(self.timeSelectedAction(sender:)), for: .touchUpInside)
                self.timeBtn = timeBtn
            }else if indexPath.section == 0 && indexPath.row == 2 {
                self.titleLabel?.removeFromSuperview()
                self.titleLabel = nil
                self.titleLabel = UILabel.init()
                
                cell?.contentView.addSubview(self.titleLabel!)
                self.titleLabel?.snp.makeConstraints({ (make) in
                    make.height.equalTo(35)
                    make.top.right.equalTo(0)
                    make.left.equalTo(15)
                })
                
                self.titleLabel?.textAlignment = .left
                self.titleLabel?.text = "提醒内容"
                
                let textField = UITextField.init()
                textField.delegate = self
                cell?.contentView.addSubview(textField)
                textField.snp.makeConstraints({ (make) in
                    make.top.equalTo((cell?.snp.centerY)!).offset(0)
                    make.left.equalTo(30)
                    make.right.equalTo(-10)
                    make.bottom.equalTo(0)
                })
                textField.text = self.model?.attribute1
                self.textView = textField
            }
            
            if indexPath.section == 1 {
                cell?.textLabel?.text = self.titleArray[indexPath.row]
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
                checkButton.isSelected = false
            }

        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
