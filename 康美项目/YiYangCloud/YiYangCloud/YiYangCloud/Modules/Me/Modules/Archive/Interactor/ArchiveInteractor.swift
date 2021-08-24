//
//  ArchiveInteractor.swift
//  YiYangCloud
//
//  Created by Cary on 2017/5/10.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit


enum UserArchive_Key_Type:String {
    case memberId               = "memberId"
    case memberRealName         = "memberRealName"
    case memberNickName         = "memberNickName"
    case memberIdNum            = "memberIdNum"
    case memberMobile           = "memberMobile"
    case memberTel              = "memberTel"
    case memberMail             = "memberMail"
    case memberPicUrl           = "memberPicUrl"
    case memberSex              = "memberSex"
    case memberBirth            = "memberBirth"
    
    case memberCountry          = "memberCountry"
    case memberState            = "memberState"
    case memberSuburb           = "memberSuburb"
    case memberAddress          = "memberAddress"
    case memberPostcode         = "memberPostcode"
    case groupId                = "groupId"
    case memberPw               = "memberPw"
    case haveDevice             = "haveDevice"
    case imei                   = "imei"
    
    func contentCheckMessage() -> String {
        switch self {
        case .memberRealName:           return "请输入真实信息名"
        case .memberNickName:           return "请输入昵称"
        case .memberIdNum:              return "请输入身份证号码"
        case .memberMobile:             return "请输入手机号码"
        case .memberTel:                return "请输入座机号码"
        case .memberMail:               return "请输入邮箱地址"
        case .memberBirth:              return "请选择出生日期"
            
        case .memberCountry:            return "请输入国家"
        case .memberState:              return "请输入省份"
        case .memberSuburb:             return "请输入区县"
        case .memberAddress:            return "请输入详细地址"
        case .memberPostcode:           return "请输入邮政编码"
        case .memberPw:                 return "请输入密码"
        case .imei:                     return "请输入imei号码"
            
        default:                        return "请检查输入是否有误"
        }
    }
}


let Notification_Refresh_HeadImg = "Notification_Refresh_HeadImg"

//Mark: 数据监测与提交
class ArchiveInteractor: BaseInteractor {
    
    typealias UserInfoInputSource = [UserArchive_Key_Type:UIView]
    
    var inputViewDic:UserInfoInputSource!
    var keyArr:[String]! = []
    
    init(_ apiString: String, viewDic:UserInfoInputSource) {
        super.init(apiString)
        
        inputViewDic = viewDic
        
        for key in inputViewDic.keys {
            keyArr.append(key.rawValue)
        }
    }
    
    // 监听所有输入源
    open func listenWithDataSource() {
        
        // 输入源数据改变时自动检查
         checkWithDataSource()
    }
    
    // 检查所有输入源 -> 返回[Key]数组
    @discardableResult
    func checkWithDataSource() -> [UserArchive_Key_Type] {
        
        var emptyInputViewArr:[UserArchive_Key_Type] = []
        
        for (key,value) in inputViewDic {
            if (value.isKind(of: UIView.self) || value.isMember(of: UIView.self)) && (value.value(forKey: "text") == nil || (value.value(forKey: "text") as! String).characters.count <= 0) {
                
                emptyInputViewArr.append(key)
            }
        }
        
        return emptyInputViewArr
    }
    
    
    override func loadDataPost(success: @escaping (JSON?) -> Void, failed fail: @escaping (String?) -> Void) {
        blockSuccess = success
        blockFailed = fail
        
        blockSuccess = { (json) in
            // 保存成功以后 头像、姓名、性别做缓存,并发送信号通知userVC刷新
//            let headImageUrl = self.inputViewDic[UserArchive_Key_Type.memberPicUrl]?.value(forKey: "text") ?? ""
//            UserCacheManager.shared().setAppCache(headImageUrl, forKey: UserModel.property.headImgURL)
            UserCacheManager.shared().setAppCache(self.inputViewDic[UserArchive_Key_Type.memberSex]?.value(forKey: "text"), forKey: UserModel.property.sex)
            UserCacheManager.shared().setAppCache(self.inputViewDic[UserArchive_Key_Type.memberRealName]?.value(forKey: "text") ?? "", forKey: UserModel.property.name)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification_Refresh_HeadImg), object: nil)
            
            success(json)
        }
        
        // 参数
        for (key,value) in inputViewDic {
            params.updateValue(value.value(forKey: "text") as? String ?? "", forKey: key.rawValue)
        }
        
        super.loadDataPost(success: blockSuccess, failed: blockFailed)
    }

}

extension UserModel {
    
    struct property {
        static let uid      = "uid"
        static let phoneNum = "phoneNum"
        static let password = "password"
        static let name     = "name"
        static let idCard   = "idCard"
        static let sex      = "sex"
        static let headImgURL  = "headImgURL"
    }
}

