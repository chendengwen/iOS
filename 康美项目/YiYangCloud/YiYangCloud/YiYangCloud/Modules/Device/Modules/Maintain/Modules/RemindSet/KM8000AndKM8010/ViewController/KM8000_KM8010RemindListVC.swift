//
//  KM8000_KM8010RemindListVC.swift
//  YiYangCloud
//
//  Created by 钟晓跃 on 2017/5/24.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

public enum RemindType:Int {
    case custom = 0
    case medicine = 1
    case clinical = 2
    
}

public enum RemindStauts:Int {
    case add = 0
    case edit = 1
}

class KM8000_KM8010RemindListVC: UIViewController {
    
    var type:RemindType = .custom {
        didSet{
            switch self.type {
            case .custom:
                self.title = "自定义提醒"
            case .clinical:
                self.title = "回诊提醒"
            case .medicine:
                self.title = "吃药提醒"
            default:
                break
            }
            
        }
    }
    
    var list = [KM8000_KM8010RemindList]()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 70
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.requestData()
        })
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configNavBar()
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        self.requestData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - UI
extension KM8000_KM8010RemindListVC{
    func configNavBar(){
        self.title = "提醒设置"
        if self.type == .custom {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(self.didClickAddBtn(sender:)))
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        }
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
    
    func switchDidChange(sender:UISwitch){
        
    }
    
    func didClickAddBtn(sender:UIBarButtonItem) {
        let VC = KM8010CustomRemindEditVC.init()
        VC.staust = .add
        self.navigationController?.pushViewController(VC, animated: true)
    }
}


// MARK: - NetWorkRequest
extension KM8000_KM8010RemindListVC{
    func requestData(){
        KMNetWork.fetchData(urlStrig: "http://watch.medquotient.com:8880/kmhc-modem-restful/services/member/remind/866545022018110?_type=json", success: {
            [unowned self]
            (json) in
            let model = KM8000_KM8010RemindListModel.model(withJSON: json!)
            let str = String.init(format: "%02d", (self.type.rawValue == 0) ? 4 : self.type.rawValue)
            self.list.removeAll()
            for listModel in (model?.content?.list)!{
                if str == listModel.sType {
                    self.list.append(listModel)
                }
            }
            self.tableView.mj_header.endRefreshing()
            self.tableView.reloadData()
        }) { (error) in
            
        }
    }
}

// MARK: - UITableViewDelegate,UITableViewDataSource
extension KM8000_KM8010RemindListVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "Cell")
            cell?.accessoryView = UISwitch.init()
            (cell?.accessoryView as! UISwitch).addTarget(self, action: #selector(self.switchDidChange(sender:)), for: .valueChanged)
        }
        let model = self.list[indexPath.row]
        var timeStr = String.init(format: "%@:%@", model.sHour!,model.sMin!)
        var dateStr = String.init(format: "%@-%@-%@", model.sYear!,model.sMon!,model.sDay!)
        if dateStr.hasPrefix("0") || dateStr.hasPrefix("/") || dateStr.hasPrefix("null") {
            dateStr = "未设置时间"
        }
        if timeStr.characters.count == 0 {
            timeStr = dateStr
        }
        cell?.textLabel?.text = timeStr
        cell?.detailTextLabel?.text = self.weekStringWithDetaiModel(model: model)
        if cell?.detailTextLabel?.text?.characters.count == 0 {
            cell?.detailTextLabel?.text = dateStr
        }
        (cell?.accessoryView as! UISwitch).isOn = (model.isvalid == "Y")
        cell?.accessoryView?.tag = indexPath.row
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.type == .custom {
            let VC = KM8010CustomRemindEditVC.init()
            VC.staust = .edit
            VC.type = self.type
            VC.model = self.list[indexPath.row]
            self.navigationController?.pushViewController(VC, animated: true)
        }else {
            let VC = KMClinicAndMdicalEditVC.init()
            VC.type = self.type
            VC.model = self.list[indexPath.row]
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.type == .custom {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //删除
            
        }
    }
}
