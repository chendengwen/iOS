//
//  DialSetViewController.swift
//  YiYangCloud
//
//  Created by zhong on 2017/5/15.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
import DGElasticPullToRefresh
import MJRefresh

class DialSetViewController: UIViewController {
    
    let title8020:[String] = ["亲情号码","SOS","求救短信"]
    
    var sosArray = ["","",""]
    
    var fmyArray = ["","","",""]
    
    var model = KM8020DialSetModel.init()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { 
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                tableView.mj_header.endRefreshing()
            })
        })
        
        return tableView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "拨号设置"
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: .done, target: self, action: #selector(self.saveAction(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        // Do any additional setup after loading the view.
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        self.loadData()
        
    }
    
    func saveAction(_ sender:UIBarButtonItem){
        self.setData()
        self.updateFamilyNumber()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - NetWork
extension DialSetViewController{
    func loadData(){
        KMNetWork.fetchData(urlStrig: "http://10.2.20.238:7000/app/device/deviceManage/3315/admin/866545022045261/contactInfo", success: {
            [unowned self]
            (json) in
            print(json!)
            self.model = KM8020DialSetModel.model(withJSON: json!)!
            self.setData()
            self.tableView.reloadData()
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
    }
    
    func updateFamilyNumber(){
        var body = ["number1":"","number2":"","number3":"","number4":""]
        body["number1"] = self.fmyArray[0]
        body["number2"] = self.fmyArray[1]
        body["number3"] = self.fmyArray[2]
        body["number4"] = self.fmyArray[3]
        let request = "http://10.2.20.238:7000/app/device/deviceManager/fmy/3315/admin/866545022045261"
        KMNetWork.fetchDataPost(urlStrig: request, parameters: body, success: {
            [unowned self]
            (json) in
            let model = KM8020DialSetModel.model(withJSON: json!)
            if model?.msg != nil && model?.msg == "Family Contact Info message send Successfully" {
                self.updateSosNumber()
            }else{
                SVProgressHUD.showError(withStatus: model?.msg!)
            }
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
    }
    
    func updateSosNumber(){
        var body = ["number1":"","number2":"","number3":""]
        body["number1"] = self.sosArray[0]
        body["number2"] = self.sosArray[1]
        body["number3"] = self.sosArray[2]
        let request = "http://10.2.20.238:7000/app/device/deviceManager/sos/3315/15361413034/866545022045261"
        KMNetWork.fetchDataPost(urlStrig: request, parameters: body, success: {
            [unowned self]
            (json) in
            let model = KM8020DialSetModel.model(withJSON: json!)
            if model?.msg != nil && model?.msg == "SOS Contact Info message send Successfully" {
                self.updateSosSms()
                
            }else{
                SVProgressHUD.showError(withStatus: model?.msg!)
            }
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
    }
    
    func updateSosSms(){
        var body = ["sms":""]
        body["sms"] = self.model.content?.list[0].sosSms
        let request = "http://10.2.20.238:7000/app/device/deviceManager/sos/3315/admin/866545022045261"
        KMNetWork.fetchDataPost(urlStrig: request, parameters: body, success: {
            [unowned self]
            (json) in
            let model = KM8020DialSetModel.model(withJSON: json!)
            if model?.msg != nil && model?.msg == "SOS Contact Info message send Successfully" {
                SVProgressHUD.showSuccess(withStatus: "消息以发送到手表")
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
}


// MARK: - Action
extension DialSetViewController{
    func setData(){
        let model:KM8020DialSetList = (self.model.content?.list[0])!
        self.sosArray[0] = model.sos1!
        self.sosArray[1] = model.sos2!
        self.sosArray[2] = model.sos3!
        self.fmyArray[0] = model.fmy1!
        self.fmyArray[1] = model.fmy2!
        self.fmyArray[2] = model.fmy3!
        self.fmyArray[3] = model.fmy4!
    }
}

extension DialSetViewController:UITextFieldDelegate,UITextViewDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag >= 10 {
            self.sosArray[textField.tag - 10] = textField.text!
        }else {
            self.fmyArray[textField.tag] = textField.text!
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.model.content?.list[0].sosSms = textView.text
    }
}

// MARK: - UITableViewDataSource,UITableViewDelegate
extension DialSetViewController: UITableViewDataSource,UITableViewDelegate{

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.title8020.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {return 4}
        if section == 1 {return 3}
        if section == 2 {return 1}
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "Cell")
            cell?.selectionStyle = .none
        }
        cell?.contentView.removeAllSubviews()
        if indexPath.section == 2 {
            let textList = UITextView.init()
            textList.delegate = self
            textList.font = UIFont.systemFont(ofSize: 15)
            cell?.contentView.addSubview(textList)
            textList.snp.makeConstraints({ (make) in
                make.left.equalTo((cell?.contentView)!).offset(18)
                make.right.equalTo((cell?.contentView)!).offset(-18)
                make.top.equalTo((cell?.contentView)!).offset(8)
                make.bottom.equalTo((cell?.contentView)!).offset(-8)
            })
            textList.text = self.model.content?.list[0].sosSms
        }else {
            let text = UITextField.init()
            text.delegate = self
            text.font = UIFont.systemFont(ofSize: 15)
            text.keyboardType = .numberPad
            cell?.contentView.addSubview(text)
            text.snp.makeConstraints({ (make) in
                make.left.equalTo((cell?.contentView)!).offset(18)
                make.right.equalTo((cell?.contentView)!).offset(-18)
                make.centerY.equalTo((cell?.contentView)!)
            })
            text.placeholder = "请输入手机号码"
            if indexPath.section == 0 {
                //亲情号码
                text.text = self.fmyArray[indexPath.row]
                text.tag = indexPath.row
            }else if indexPath.section == 1{
                //sos号码
                text.text = self.sosArray[indexPath.row]
                text.tag = indexPath.row + 10
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 150
        }else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 40))
        view.backgroundColor = UIColor(red:0.96, green:0.95, blue:0.97, alpha:1.00)
        let lab = UILabel.init()
        lab.text = self.title8020[section]
        lab.textColor = UIColor.init(hex: 0x999999)
        view.addSubview(lab)
        lab.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(18)
            make.centerY.equalTo(view)
        }
        return view
    }
}
