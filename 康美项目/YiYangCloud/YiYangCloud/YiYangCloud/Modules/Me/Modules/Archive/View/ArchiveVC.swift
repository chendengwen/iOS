//
//  ArchiveVC.swift
//  YiYangCloud
//
//  Created by Cary on 2017/5/10.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import SVProgressHUD
import HandyJSON
import ReactiveCocoa
import Alamofire
import AlamofireImage

class ArchiveVC: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var headImgV: UIImageView!
    @IBOutlet weak var nameFieldV: UITextField!
    @IBOutlet weak var genderSwitch: ZJSwitch!
    @IBOutlet weak var IDFieldV: UITextField!
    @IBOutlet weak var phoneNumFieldV: UITextField!
    @IBOutlet weak var liveAdressFieldV: UITextField!
    @IBOutlet weak var householdL: UILabel!
    @IBOutlet weak var birthdayL: UILabel!
    
    var inputViewDic:[UserArchive_Key_Type:UIView]!
    
    ///相机，相册
    fileprivate lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.navigationBar.barTintColor = UIColorFromRGBA(0x507AF8)
        picker.navigationBar.tintColor = UIColor.white
        picker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        picker.delegate = self
        return picker
    }()
    
    fileprivate lazy var sheetView:KMSheetView = {
        return KMSheetView()
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navBarBgAlpha = "1.0"
        loadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if interactor != nil {
            interactor?.request?.cancel()
            interactor = nil
            
            SVProgressHUD.dismiss()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        genderSwitch.onText = "男"
        genderSwitch.offText = "男"
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
        headImgV.text = UserCacheManager.shared().cache(forKey: UserModel.property.headImgURL) as? String
        inputViewDic = [
            UserArchive_Key_Type.memberPicUrl:     headImgV,
            UserArchive_Key_Type.memberRealName:     nameFieldV,
            UserArchive_Key_Type.memberSex:       genderSwitch,
            UserArchive_Key_Type.memberIdNum:        IDFieldV,
            UserArchive_Key_Type.memberMobile:     phoneNumFieldV,
            UserArchive_Key_Type.memberAddress:  liveAdressFieldV,
            UserArchive_Key_Type.memberSuburb:    householdL,
            UserArchive_Key_Type.memberBirth:     birthdayL,
        ]
        
        interactor = ArchiveInteractor.init(APIs.API_User_Type.uploadArchive.getAPI(), viewDic: self.inputViewDic)
        
        guard let imageURL = UserCacheManager.shared().cache(forKey: UserModel.property.headImgURL) as? String, imageURL.characters.count > 0 else {
            return
        }
        headImgV.af_setImage(withURL: URL.init(string: imageURL)!)
        self.headImgV.text = imageURL
    }

    
    @IBAction func switch_gender_click(_ sender: ZJSwitch) {
    }
    
    //Mark: 点击提交
    @IBAction func saveArchive(_ sender: Any) {
        
        resignFirstResponder()
        
        //点击之后开始观察输入框
        listenWithDataSource()
        
//        _ = (interactor as! ArchiveInteractor).checkWithDataSource().count <= 0 &&
        interactor?.loadDataPost(success: { (json) in
            SVProgressHUD.showSuccess(withStatus: "保存成功")
//            self.popBack()
        }, failed: { (message) in
            SVProgressHUD.showError(withStatus: message ?? "保存失败，请重试")
        })
    }
    
    //Mark: UITableViewDelegate.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // 选择头像
            self.sheetView.dataArray = ["相册","相机"]
            self.sheetView.finishBlock = { (text:String, index:Int) in
                
                let bool = index == 0
                self.imagePicker.sourceType = bool ? UIImagePickerControllerSourceType.photoLibrary : UIImagePickerControllerSourceType.camera
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            
            self.sheetView.showInMask()
            
        }else if indexPath.row == 6 {
            // 户籍地
            let pickerView = KMPickerView()
            pickerView.initType(.city, defaultValue: ["浙江","绍兴市","越城区"])
            pickerView.finishBlock = {address in
                self.householdL.text = address
            }
            pickerView.showInMask()
            
        }else if indexPath.row == 7 {
            // 出生日期
            let pickerView = KMPickerView()
            pickerView.initType(.day, defaultValue: ["1988","08","18"])
            pickerView.finishBlock = {birthday in
                self.birthdayL.text = birthday
            }
            pickerView.showInMask()
        }
    }
    
    //Mark: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        //获得照片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        headImgV.image = image
        
        uploadHeadImage(image)
    }
    
    func uploadHeadImage(_ image:UIImage) {
        SVProgressHUD.show(withStatus: "请稍后...")
        
        BaseInteractor.init(APIs.API_File_Type.uploadHeadImg.getAPI()).upload({ (multipartFormData) in
            // 利用 multipartFormData.append(data: withName: )添加参数
            let data = UIImageJPEGRepresentation(image, 0.2)!
            let imageName = String(describing: NSDate().timeIntervalSince1970) + ".png"
            multipartFormData.append(data, withName: "file", fileName: imageName, mimeType: "image/png")
        }, success: { (json) in
            DispatchQueue.main.async(execute: {
                SVProgressHUD.dismiss()
                SVProgressHUD.showSuccess(withStatus: "上传成功")
                
                if json != nil {
                    let jsonDic:Dictionary<String,Any> = json as! Dictionary<String, Any>
                    // 保存图片url
                    UserCacheManager.shared().setAppCache(jsonDic["content"], forKey: "headImgURL")
                    self.headImgV.text = jsonDic["content"] as? String                    
                }
                
            })
        }, failed: { (message) in
            SVProgressHUD.showError(withStatus: message ?? "上传失败，请重试")
        })
    }
}

extension ArchiveVC {
    
    func loadData() {
        
        SVProgressHUD.show(withStatus: "正在加载...")
        BaseInteractor(APIs.API_User_Type.achieveArchive.getAPI() + "3315").loadData(success: { (json) in
            
             let dic = try? JSONSerialization.jsonObject(with: ((json as! String).data(using: .utf8)!), options: .allowFragments) as! [String: Any]
            print("json ===== %@",dic?["content"] ?? "null")
            
            DispatchQueue.main.async(execute: {
                SVProgressHUD.dismiss()
                if let content = dic?["content"] as? Dictionary<String,Any> {
                    let memberProfile = content["memberProfile"] as? Dictionary<String,Any>
                    
                    self.nameFieldV.text = memberProfile?["memberRealName"] as? String
                    self.genderSwitch.isOn = (memberProfile?["memberSex"] as! Int) == 1
                    self.IDFieldV.text = memberProfile?["memberIdNo"] as? String
                    self.phoneNumFieldV.text = memberProfile?["memberMobile"] as? String
                    self.liveAdressFieldV.text = memberProfile?["memberAddress"] as? String
                    self.householdL.text = content["memberSuburb"] as? String
                    self.birthdayL.text = content["memberBirth"] as? String
                }
            })
        }) { (message) in
            SVProgressHUD.showError(withStatus: message ?? "数据获取失败，请重试")
        }
    }

    func listenWithDataSource() {

//        let nameSignal = nameFieldV.reactive.continuousTextValues
//        let IDSignal = IDFieldV.reactive.continuousTextValues
//        let mobileSignal = phoneNumFieldV.reactive.continuousTextValues
//        let adressSignal = liveAdressFieldV.reactive.continuousTextValues
        
//        let combineSignal = 
        
//        householdL.reactive.text
//        birthdayL.reactive.text
        
            
//            .observeValues { (text) in
//                print(text)
//        }
    }
    
}



