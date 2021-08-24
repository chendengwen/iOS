//
//  FamilyGroupVC.swift
//  YiYangCloud
//
//  Created by gary on 2017/4/13.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import HandyJSON
import SVProgressHUD

class FamilyGroupVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    fileprivate let identifer = "familyMemberCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 赋初始值，防止为nil
        let uid = UserCacheManager.shared().userModel.uid
        self.interactor = FamilyInteractor(APIs.API_Family_Type.memberlist.getAPI() + "3315",1)
        self.tableView.dataArray = []
        
        func setupTableView() {
            self.tableView.register(UINib.init(nibName: "FamilyMemberCell", bundle: nil), forCellReuseIdentifier: identifer)
            
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
                }, modelType: FamilyMember())
                
            }) { (message) in
                print(message ?? "")
                self.tableView.dg_stopLoading()
            }
        }
        
        setupTableView()
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.tableView.dataArray?.removeAll()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "sugueID_FamilyDetail") {
            let ctl = segue.destination as! FamilyDetailVC
            ctl.model = self.tableView.dataArray![(sender as! IndexPath).row] as? FamilyMember
        } else if (segue.identifier == "sugueID_LocationRecord") {
            let ctl = segue.destination as! LocationRecordVC
            ctl.model = self.tableView.dataArray![(sender as! IndexPath).row] as! FamilyMember
        }
    }
    
    @IBAction func gotoSearchVC(_ sender: Any) {
        let searchViewController = KMSearchViewController.init(self, operationblock: {
            //需要回调时在这里回调
        }, dismissBlock: {})
        
        let nav = UINavigationController.init(rootViewController:searchViewController)
        nav.navigationBar.isHidden = true
        self.present(nav, animated: false, completion: nil)
    }
    
}

extension FamilyGroupVC:KMTableViewAction,KMViewAction {

    @objc func refreshData() {
        (self.interactor as! FamilyInteractor).reloadData()
    }
}

extension FamilyGroupVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.dataArray!.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FamilyMemberCell = tableView.dequeueReusableCell(withIdentifier: identifer, for: indexPath) as! FamilyMemberCell
        
        cell.model = tableView.dataArray![indexPath.row] as! FamilyMember
        cell.locationBlock = {
            self.performSegue(withIdentifier: "sugueID_LocationRecord", sender: indexPath)
        }
        cell.telephoneBlock = { phoneNum in
            let callWeb = UIWebView()
            let request = URLRequest.init(url: URL.init(string: "tel:" + phoneNum!)!)
            callWeb.loadRequest(request)
            UIApplication.shared.keyWindow?.addSubview(callWeb)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "sugueID_FamilyDetail", sender: indexPath)
        self.push(toVC: ClassPrex + "HtmlViewController", params: ["title":"家人详情","url":"http://10.2.20.234:8080/#/health_information"])
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        SVProgressHUD.show(withStatus: "请稍后...")
//        UserCacheManager.shared().userModel.uid
        // 接口后拼接json: memberid、followerId
        let interactor = BaseInteractor.init(APIs.API_Family_Type.deleteMember.getAPI())
        interactor.params = ["memberId":"3315","followerId":(tableView.dataArray?[indexPath.row] as! FamilyMember).memberId ?? ""]
        interactor.loadDataPost(success: { (data) in
            DispatchQueue.main.async(execute: {
                SVProgressHUD.dismiss()
                // 删除对应的单元格
                tableView.dataArray!.remove(at: indexPath.row)
                tableView.beginUpdates()
                tableView.deleteRow(at: IndexPath.init(item:indexPath.row,section:0), with: .automatic)
                tableView.endUpdates()
            })
        }, failed: { (message) in
            SVProgressHUD.showError(withStatus: message ?? "关注失败，请重试")
        })

    }
}


