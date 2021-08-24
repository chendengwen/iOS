//
//  KM8010DialSetViewController.swift
//  YiYangCloud
//
//  Created by 钟晓跃 on 2017/5/26.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
import DGElasticPullToRefresh
import MJRefresh

class KM8010DialSetViewController: UIViewController {
    
    let title8000:[String] = ["通话设置","亲情号码","紧急号码"]
    
    var sosArray = ["","",""]
    
    var fmyArray = ["","",""]
    
    var model = KM8000DialSetModel.init()
    
    var timeBtn:UIButton?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView.init()
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.loadData()
        })
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "拨号设置"
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: .done, target: self, action: #selector(self.saveAction(sender:)))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        // Do any additional setup after loading the view.
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - NetWork
extension KM8010DialSetViewController{
    func loadData(){
        KMNetWork.fetchData(urlStrig: "http://watch.medquotient.com:8880/kmhc-modem-restful/services/member/deviceManager/13691993691/866545022018110?_type=json", success: {
            [unowned self]
            (json) in
            self.model = KM8000DialSetModel.model(withJSON: json!)!
            self.setData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.reloadData()
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
    }
}

// MARK: - Action
extension KM8010DialSetViewController{
    func setData(){
        let model:KM8000DialSetList = (self.model.content?.list[0])!
        self.sosArray[0] = model.sosPhoneNo1!
        self.sosArray[1] = model.sosPhoneNo2!
        self.sosArray[2] = model.sosPhoneNo3!
        self.fmyArray[0] = model.fmlyPhoneNo1!
        self.fmyArray[1] = model.fmlyPhoneNo2!
        self.fmyArray[2] = model.fmlyPhoneNo3!
    }
    
    func saveAction(sender:UIBarButtonItem){
        
    }
    
    func changeSwitch(sender:UISwitch){
        
    }
    
}

// MARK: - UITableViewDataSource,UITableViewDelegate
extension KM8010DialSetViewController: UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.title8000.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {return 1}
        if section == 1 {return 3}
        if section == 2 {return 3}
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "\(indexPath.section)"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: identifier)
            cell?.selectionStyle = .none
        }
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell?.textLabel?.text = "防打扰"
                let mSwitch = UISwitch.init()
                mSwitch.addTarget(self, action: #selector(self.changeSwitch(sender:)), for: .valueChanged)
                mSwitch.isOn = (self.model.content?.list[0].nonDistrub != "0")
                cell?.accessoryView = mSwitch
            }
        }else {
            cell?.contentView.removeAllSubviews()
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
            if indexPath.section == 1 {
                //亲情号码
                text.text = self.fmyArray[indexPath.row]
                text.tag = indexPath.row
            }else if indexPath.section == 2{
                //sos号码
                text.text = self.sosArray[indexPath.row]
                text.tag = indexPath.row + 10
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 40))
        view.backgroundColor = UIColor(red:0.96, green:0.95, blue:0.97, alpha:1.00)
        let lab = UILabel.init()
        lab.text = self.title8000[section]
        lab.textColor = UIColor.init(hex: 0x999999)
        view.addSubview(lab)
        lab.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(18)
            make.centerY.equalTo(view)
        }
        return view
    }
    
}

// MARK: - UITextFieldDelegate
extension KM8010DialSetViewController:UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag >= 10 {
            self.sosArray[textField.tag - 10] = textField.text!
        }else {
            self.fmyArray[textField.tag] = textField.text!
        }
    }
}
