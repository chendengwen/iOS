//
//  KMClinicAndMdicalEditVC.swift
//  YiYangCloud
//
//  Created by 钟晓跃 on 2017/5/25.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class KMClinicAndMdicalEditVC: UIViewController {
    
    var type:RemindType = .custom {
        didSet{
            switch self.type {
            case .custom:
                self.title = "自定义提醒"
            case .clinical:
                self.title = "回诊提醒"
            case .medicine:
                self.title = "吃药提醒"
            }
            
        }
    }
    
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

// MARK: - Action
extension KMClinicAndMdicalEditVC{
    
    func timeAlertSelectedAction(sender:UIButton){
        let index = sender.tag - 3000
        
        if index == 1 {
//            self.model?.remindTime = self.format.string(from: (self.datePicker?.date)!)
            
            let strDate = self.format.string(from: (self.datePicker?.date)!)
            if self.type == .medicine {
                 self.timeBtn?.setTitle(strDate.substring(from: strDate.index(strDate.endIndex, offsetBy: -5)), for: .normal)
            }else {
                self.timeBtn?.setTitle(strDate, for: .normal)
            }
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
extension KMClinicAndMdicalEditVC{
    func configNavBar(){
        self.title = "提醒设置"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.didClickSaveBtn(sender:)))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    
    func weekStringWithDetaiModel(model:KM8000_KM8010RemindList) -> String {
        var str = String.init()
        if model.t1Hex == "1" { str += " 一" }
        if model.t2Hex == "1" { str += " 二" }
        if model.t3Hex == "1" { str += " 三" }
        if model.t4Hex == "1" { str += " 四" }
        if model.t5Hex == "1" { str += " 五" }
        if model.t6Hex == "1" { str += " 六" }
        if model.t7Hex == "1" { str += " 日" }
        return str
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
        if self.type == .medicine{
            datePicker.datePickerMode = .time
        }else{
            datePicker.datePickerMode = .dateAndTime
        }
        
//        datePicker.minimumDate = Date.init()
        self.datePicker = datePicker
        
        self.timeSelected?.containerView = view
        self.timeSelected?.show()
    }
}

extension KMClinicAndMdicalEditVC:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.type == .clinical {
            return 1
        }else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
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
        
        if indexPath.section == 0 && indexPath.row == 0 {
            cell?.textLabel?.text = "开启"
            cell?.accessoryView = UISwitch.init()
            (cell?.accessoryView as! UISwitch).addTarget(self, action: #selector(self.switchDidChange(sender:)), for: .valueChanged)
            (cell?.accessoryView as! UISwitch).isOn = (self.model?.isvalid == "Y")
            
        }else if indexPath.section == 0 && indexPath.row == 1 {
            cell?.textLabel?.text = "时间"
            let timeBtn = UIButton.init()
            timeBtn.setTitleColor(UIColor.gray, for: .normal)
            timeBtn.contentHorizontalAlignment = .right
            cell?.accessoryView = timeBtn
            timeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            timeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
            timeBtn.frame = CGRect.init(x: 0, y: 0, width: 200, height: 35)
            if self.type == .medicine {
                var time = String.init(format: "%@:%@", (self.model?.sHour!)!,(self.model?.sMin!)!)
                time = time.replacingOccurrences(of: "null", with: "")
                timeBtn.setTitle(time, for: .normal)
            }else{
                var day = String.init(format: "%@-%@-%@", (self.model?.sYear)!,(self.model?.sMon)!,(self.model?.sDay)!)
                var hour = String.init(format: "%@:%@", (self.model?.sHour!)!,(self.model?.sMin!)!)
                day = day.contains("null") ?"":day;
                hour = hour.contains("null") ?"":hour
                let time = String.init(format: "%@ %@", day,hour)
                timeBtn.setTitle(time, for: .normal)
            }
            timeBtn.addTarget(self, action: #selector(self.timeSelectedAction(sender:)), for: .touchUpInside)
            self.timeBtn = timeBtn
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
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "重复提醒"
        }
        return nil
    }
}
