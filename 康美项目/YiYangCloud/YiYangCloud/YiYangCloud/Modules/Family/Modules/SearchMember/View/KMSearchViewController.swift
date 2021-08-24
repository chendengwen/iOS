//
//  KMSearchViewController.swift
//  YiYangCloud
//
//  Created by Cary on 2017/5/15.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import ESPullToRefresh
import HandyJSON
import SVProgressHUD

class KMSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tipsLab: UILabel!
    @IBOutlet weak var tableView: UITableView!
    fileprivate let identifer = "searchMemberCell"
    
    var dismissBlock:() = {}()
    var operationblock:() = {}()
    
    init(_ hander:UIViewController, operationblock:() -> Void , dismissBlock:(() -> Void)) {
        super.init(nibName: nil, bundle: nil)
        self.operationblock = operationblock()
        self.dismissBlock = dismissBlock()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchBar.becomeFirstResponder()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        UIApplication.shared.statusBarStyle = .lightContent
        return .`default`
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.interactor = BaseInteractor(APIs.API_Family_Type.searchMember.getAPI())
        self.tableView.dataArray = []
        
        func setupTableView() {
            self.tableView.register(UINib.init(nibName: "SearchMemberCell", bundle: nil), forCellReuseIdentifier: identifer)
            self.tableView.dataSource = self
            
            self.tableView.es_addPullToRefresh {
                [weak self] in
                
                self?.tableView.pageIndex = 1
                self?.tableView.loadingState = .refreshing
                self?.refreshData()
            }
            
            self.tableView.es_addInfiniteScrolling {
                [weak self] in

                self?.tableView.addOnePage()
                self?.refreshData()
            }
        }
        
        func loadData() {
            self.interactor?.loadData(success: { (json) in

                self.tableView.loadDataFinish(json as? String, viewBlock: {
                    self.tableView.loadViewFinish(true)
                    self.tableView.reloadData()
                }, modelType: SearchMemberModel())
                
            }) { (message) in
//                print(message ?? "")
                self.tableView.loadViewFinish(false)
            }
        }
        
        setupTableView()
        loadData()
                
        UIApplication.shared.statusBarStyle = .default
    }
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        actionCancel()
    }
    
}
    

extension KMSearchViewController:UISearchBarDelegate,UITextFieldDelegate {

    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let a:Int? = Int(text)
        if (a != nil && a! >= 0) || text == "" {
            return true
        }
        return false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if (searchBar.text?.characters.count)! >= 2 {
            self.view.bringSubview(toFront: tableView)
            refreshData()
        } else {
            self.view.bringSubview(toFront: bgView)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text?.characters.count)! >= 2 {
            self.view.bringSubview(toFront: tableView)
            refreshData()
        } else {
            self.view.bringSubview(toFront: bgView)
        }
    }
    
}

extension KMSearchViewController:UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.dataArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifer, for: indexPath) as! SearchMemberCell
        // 关注
        cell.model = self.tableView.dataArray![indexPath.row] as! SearchMemberModel
        cell.careBlock = { _ in
            
            SVProgressHUD.show(withStatus: "请稍后...")
            
            let interactor = BaseInteractor.init(APIs.API_Family_Type.concernedMember.getAPI())
            interactor.params = ["memberId":"3315","followerId":cell.model.memberId ?? ""]
            
            interactor.loadDataPost(success: { (data) in
                DispatchQueue.main.async(execute: {
                    SVProgressHUD.dismiss()
                    // 删除对应的单元格
                    self.tableView.dataArray!.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [IndexPath.init(item:indexPath.row,section:0)], with: .automatic)
                })
            }, failed: { (message) in
                SVProgressHUD.showError(withStatus: message ?? "关注失败，请重试")
            })
        }
        
        return cell
    }
}

extension KMSearchViewController:KMTableViewAction,KMViewAction {
    
    @objc func refreshData() {
        interactor?.api = APIs.API_Family_Type.searchMember.getAPI() + searchBar.text!  + "/10" + "/" + "\(self.tableView.pageIndex)"
        interactor?.reloadData()
    }
    
    @objc func actionCancel() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.dismiss(animated: false, completion: { self.dismissBlock })
    }
}


