//
//  KM8020RemindSetVC.swift
//  YiYangCloud
//
//  Created by 钟晓跃 on 2017/5/19.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh
import SVProgressHUD

class KM8020RemindSetVC: UITableViewController {
    
    var imei:String?
    
    var models = [KMRemindDetailModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        self.configNavBar()
        self.configView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - Action
extension KM8020RemindSetVC{
    func didClickRightBtn(sender:UIBarButtonItem){
        let VC = KM8020RemindEditVC.init()
        VC.status = .KM8020RemindStatusAdd
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func loadData(){
        
        KMNetWork.fetchData(urlStrig: "http://10.2.20.234:7000/app/device/remind/865946021011083/KM8020", success: {
            [unowned self]
            (json) in
            let model = KMRemindModel.model(withJSON: json!)
            self.models = (model?.content?.list)!
            self.tableView.mj_header.endRefreshing()
            self.tableView.reloadData()
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    func deleteData(indexPath:IndexPath){
        let model = self.models[indexPath.row]
//        let team = Int(model.team!)!
//        let type = Int(model.type!)!
        let request = String.init(format: "http://10.2.20.234:7000/app/device/removeRemind/t9/%@/%@/%@",
            "865946021011083",model.team!,model.type!)
        
        KMNetWork.fetchDataPost(urlStrig: request, parameters: nil, success: {
            [unowned self]
            (json) in
            let model = KMRemindModel.model(withJSON: json!)
            if model?.errorCode == nil {
                SVProgressHUD.showSuccess(withStatus: "删除消息以发送到手表")
                self.loadData()
            }
            
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
    }
    
    func weekStringWithDetaiModel(model:KMRemindDetailModel) -> String {
        var str = String.init()
        if model.mon == "1" { str += " 一" }
        if model.tue == "1" { str += " 二" }
        if model.wed == "1" { str += " 三" }
        if model.thu == "1" { str += " 四" }
        if model.fri == "1" { str += " 五" }
        if model.sat == "1" { str += " 六" }
        if model.sun == "1" { str += " 日" }
        return str
    }
}


// MARK: - UITableViewDataSource,UITableViewDelegate
extension KM8020RemindSetVC{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "default"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: identifier)
        }
        let model = self.models[indexPath.row]
        cell?.detailTextLabel?.numberOfLines = 0

        cell?.textLabel?.text = model.remindTime
        var str:String?
//        if model.type == nil {
//            model.type = "0"
//        }
        let status = Int(model.type!)!
        
        switch status {
        case 0:
            str = "一次"
        case 1:
            str = "每次"
        case 2:
            str = self.weekStringWithDetaiModel(model: model)
        default:
            break
        }
        str! += "\n\(model.remindText!)"
        cell?.detailTextLabel?.text = str
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let VC = KM8020RemindEditVC.init()
        VC.model = self.models[indexPath.row]
        VC.imei = self.imei
        VC.status = .KM8020RemindStatusEdit
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteData(indexPath: indexPath)
        }
    }
}

// MARK: - UI
extension KM8020RemindSetVC {
    func configNavBar(){
        self.title = "提醒设置"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(self.didClickRightBtn(sender:)))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    
    func configView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
             [unowned self] in
            self.loadData()
        })
    }
}

