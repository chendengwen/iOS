//
//  FamilyRecordVC.swift
//  YiYangCloud
//
//  Created by Cary on 2017/5/12.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import SVProgressHUD
import DGElasticPullToRefresh

class FamilyRecordVC: UITableViewController {

    
    fileprivate let identifer = "familyRecordCell"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navBarBgAlpha = "1.0"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.interactor = BaseInteractor(APIs.API_Family_Type.memberlist.getAPI() + "3315" + "/0")
        self.tableView.dataArray = []
        
        func setupTableView() {
            self.tableView.register(UINib.init(nibName: "FamilyRecordCell", bundle: nil), forCellReuseIdentifier: identifer)
            self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
            
            let loadingView = DGElasticPullToRefreshLoadingViewCircle()
            loadingView.tintColor = UIColor.white
            
            self.tableView.dg_addPullToRefreshWithActionHandler({
                [unowned self] in
                self.tableView.loadingState = .refreshing
                self.refreshData()
                }, loadingView: loadingView)
            
            self.tableView.dg_setPullToRefreshFillColor(UIColor(red:0.35, green:0.49, blue:0.94, alpha:1.00))
        }
        
        func loadData() {
            self.interactor?.loadData(success: { (json) in
                
                self.tableView.loadDataFinish(json as? String, viewBlock: {
                    self.tableView.loadingState = .normal
                    self.tableView.dg_stopLoading()
                    self.tableView.reloadData()
                }, modelType: FamilyRecordModel())
            }) { (message) in
                self.tableView.dg_stopLoading()
                SVProgressHUD.dismiss()
            }
        }
        
        setupTableView()
        
        SVProgressHUD.show(withStatus: "正在加载...")
        loadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableView.dataArray!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifer, for: indexPath) as! FamilyRecordCell
        // 关注
        cell.model = (self.tableView.dataArray![indexPath.row] as? FamilyRecordModel)!
        cell.agreenBlock = { _ in
            
            SVProgressHUD.show(withStatus: "请稍后...")
            
            let interactor = BaseInteractor.init(APIs.API_Family_Type.concernedMember.getAPI())
            interactor.params = ["memberId":UID,"followerId":cell.model.memberId ?? "","accept":"1"]
            
            interactor.loadDataPost(success: { (data) in
                DispatchQueue.main.async(execute: {
                    SVProgressHUD.dismiss()
                    // 删除对应的单元格
                    self.tableView.dataArray!.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [IndexPath.init(item:indexPath.row,section:0)], with: .automatic)
                })
            }, failed: { (message) in
                SVProgressHUD.showError(withStatus: message ?? "同意失败，请重试")
            })
        }
        
        return cell
    }

}

extension FamilyRecordVC:KMTableViewAction {
    
    @objc func refreshData() {
        self.interactor?.reloadData()
    }
    
}
