//
//  ChangeWearViewController.swift
//  YiYangCloud
//
//  Created by zhong on 2017/5/8.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChangeWearViewController: UITableViewController {
    
    var model:FamilyListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "变更穿戴绑定"
        
        self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.model == nil {
            return 0
        }
        return self.model!.content.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WearCell", for: indexPath)
        (cell as! WearCell).model = self.model?.content[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        let notifi = Notification.init(name: Notification.Name(rawValue: "ChangeWear"), object: nil, userInfo: nil)
        NotificationCenter.default.post(notifi)
        (cell as! WearCell).selectBtn.isSelected = !(cell as! WearCell).selectBtn.isSelected 
    }

}


// MARK: - NetRequest
extension ChangeWearViewController {
    func loadData(){
        
        SVProgressHUD.show()
        KMNetWork.fetchData(urlStrig: "http://\(ServerAddress)/app/member/findMemberFamilyList/3315/0", success: {
            [unowned self]
            (json) in
            self.model = FamilyListModel.model(withJSON: json!)
            self.tableView.reloadData()
            
            SVProgressHUD.dismiss()

        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
    }
}
