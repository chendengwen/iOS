//
//  KM8000_KM8010RemindSetVC.swift
//  YiYangCloud
//
//  Created by 钟晓跃 on 2017/5/23.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class KM8000_KM8010RemindSetVC: UIViewController {
    
    var imei:String?
    
    var type:String?
    
    let titleArray = ["回诊提醒","吃药提醒","自定义提醒"]
    
    let detailArray = ["可设置定时提醒功能","可设置定时提醒功能","可设置定时提醒功能"]
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 70
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                tableView.mj_header.endRefreshing()
            })
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


// MARK: - UI
extension KM8000_KM8010RemindSetVC{
    func configNavBar(){
        self.title = "提醒设置"
    }
}

// MARK: - UITableViewDataSource,UITableViewDelegate
extension KM8000_KM8010RemindSetVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.type == "1" {
            return 2
        }else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! KMReminSetCell?
        if cell == nil {
            cell = KMReminSetCell.init(style: .subtitle, reuseIdentifier: "cell")
            cell?.accessoryType = .disclosureIndicator
        }
        cell?.titleLabel.text = self.titleArray[indexPath.row]
        cell?.detailLabel.text = self.detailArray[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let VC = KM8000_KM8010RemindListVC.init()
        if indexPath.row == 0 {
            VC.type = .clinical
        }else if indexPath.row == 1 {
            VC.type = .medicine
        }else if indexPath.row == 2 {
            VC.type = .custom
        }
        self.navigationController?.pushViewController(VC, animated: true)
    }
}
