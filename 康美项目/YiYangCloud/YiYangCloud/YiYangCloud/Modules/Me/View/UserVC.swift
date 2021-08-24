//
//  UserVC.swift
//  YiYangCloud
//
//  Created by Cary on 2017/5/8.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import MessageUI
import AlamofireImage

class UserVC: UITableViewController {
    
    @IBOutlet weak var headImg: UIImageView!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navBarBgAlpha = "0.0"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColorFromRGBA(0x507AF8)
        
        // tableView背景色块
        let backgroundView = UIView.init(frame: CGRect(x:0,y:0,width:self.tableView.frame.width,height:self.tableView.frame.height))
        backgroundView.backgroundColor = UIColor.white
        let colorV = UIView.init(frame: CGRect(x:0,y:0,width:self.tableView.frame.width,height:200))
        colorV.backgroundColor = UIColorFromRGBA(0x507AF8)
        backgroundView.addSubview(colorV)
        self.tableView.backgroundView = backgroundView
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshHeadImg), name: NSNotification.Name(rawValue: Notification_Refresh_HeadImg), object: nil)
        
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
        headImg.layer.borderColor = UIColor.white.cgColor
        headImg.layer.borderWidth = 2
        refreshHeadImg()
        
    }
    
    //Mark: ButtonClick
    @IBAction func loginButtonClick(_ sender: Any) {
        
    }
    
    //Mark: 刷新头像
    func refreshHeadImg() {
        
        loginBtn.setTitle(UserCacheManager.shared().cache(forKey: UserModel.property.name) as? String ?? UserCacheManager.shared().cache(forKey: UserModel.property.phoneNum) as? String, for: .normal)
        
        guard let imageURL = UserCacheManager.shared().cache(forKey: UserModel.property.headImgURL) as? String , imageURL.characters.count > 0 else {
            return
        }
        headImg.af_setImage(withURL: URL.init(string: imageURL)!)
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.init(frame: CGRect(x:0,y:0,width:tableView.frame.size.width,height:10))
        header.backgroundColor = UIColor.white
        return header
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {  //  意见反馈
            sendMail()
        }
    }

}

extension UserVC:UINavigationControllerDelegate,MFMailComposeViewControllerDelegate {
    
    func sendMail() {
        if MFMailComposeViewController.canSendMail(){
            let controller = MFMailComposeViewController()
            controller.title = "意见反馈"
            //设置代理
            controller.mailComposeDelegate = self
            //设置主题
            controller.setSubject("意见与建议")
            //设置收件人
            controller.setToRecipients(["DeviceBS1@kmhealthcloud.com"])
            //设置抄送人
//            controller.setCcRecipients(["b1@hangge.com","b2@hangge.com"])
            //设置密送人
//            controller.setBccRecipients(["c1@hangge.com","c2@hangge.com"])
            
            //添加图片附件
//            let path = Bundle.main.path(forResource: "hangge.png", ofType: "")
//            let url = URL(fileURLWithPath: path!)
//            let myData = try! Data(contentsOf: url)
//            controller.addAttachmentData(myData, mimeType: "image/png",fileName: "swift.png")
            
            //设置邮件正文内容（支持html）
            controller.setMessageBody("邮件正文", isHTML: false)
            
            //打开界面
            self.present(controller, animated: true, completion: nil)
        }else{
            print("本设备不能发送邮件")
        }
    }
    
    //发送邮件代理方法
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
        switch result{
        case .sent:
            print("邮件已发送")
        case .cancelled:
            print("邮件已取消")
        case .saved:
            print("邮件已保存")
        case .failed:
            print("邮件发送失败")
        }
    }
}

