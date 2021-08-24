//
//  APIs.swift
//  YiYangCloud
//
//  Created by gary on 2017/4/26.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import Alamofire

let baseURL = "http://120.132.126.13"
let port = ":7000/"

protocol APIProtocol {
    func getAPI() -> String
}

enum APIs {
    
    static func joinFullAPI(_ path:String) -> String {
        return baseURL + port + path + "/"
    }
    
    static func joinFullImageAPI(_ path:String) -> String {
        return baseURL + port + path + "/"
    }
    
    public enum API_Login_Type:APIProtocol {
        case login              
        case regist
        case registCode
//        case reRegistCode
        case forgetPSD
        case forgetPSDCode
        
        func getAPI() -> String {
            switch self {
                case .login :       return APIs.joinFullAPI("login/loginSubmit")
                case .regist :      return APIs.joinFullAPI("app/member/auth")
                case .registCode :  return APIs.joinFullAPI("app/member/regist_get")
//                case .reRegistCode :  return APIs.joinFullAPI("app/member/reRegist")
                case .forgetPSD :   return APIs.joinFullAPI("app/member/setPassBySms")
                case .forgetPSDCode :   return APIs.joinFullAPI("app/member/forgetPassword")
                
            }
        }
    }
    
    public enum API_Family_Type:APIProtocol {
        case memberlist
//        case addMember
        case deleteMember
        case searchMember
        case concernedMember    // 家庭成员绑定
        case LBSRecordNormal    // 普通定位
        case LBSRecordEvent     // 求救定位
        
        func getAPI() -> String {
            switch self {
            case .memberlist :      return APIs.joinFullAPI("app/member/findMemberFamilyList")
//            case .addMember :       return APIs.joinFullAPI("addBundleFamily")
            case .deleteMember :       return APIs.joinFullAPI("app/member/deleteBundleFamily")
            case .searchMember :    return APIs.joinFullAPI("app/member/findMemberList")
            case .concernedMember : return APIs.joinFullAPI("app/member/addBundleFamily")
            case .LBSRecordNormal :    return APIs.joinFullAPI("app/member/getLbsReguler")
            case .LBSRecordEvent : return APIs.joinFullAPI("app/member/getLbsEvent")
            
            }
        }
    }

    public enum API_User_Type:APIProtocol {
        case account
        case uploadArchive
        case achieveArchive
        case feedback
        case message
        case sth
        
        func getAPI() -> String {
            switch self {
            case .account :             return ""
            case .uploadArchive :       return APIs.joinFullAPI("app/member/updateMember")
            case .achieveArchive :       return APIs.joinFullAPI("app/member/queryMemberDetailById")
            case .feedback :            return ""
            case .message :             return ""
            case .sth :                 return ""
                
                
            }
        }
    }
    
    public enum API_File_Type:APIProtocol {
        case uploadHeadImg
        case getHeadImg
        case uploadFile
        case getFile
        
        func getAPI() -> String {
            switch self {
            case .uploadHeadImg :       return APIs.joinFullImageAPI("app/member/fileUpload/upload")
            case .getHeadImg :          return APIs.joinFullImageAPI("app/member/style/headImg")
            case .uploadFile :          return APIs.joinFullImageAPI("")
            case .getFile :             return ""
            }
        }
    }


    static func qqqq() -> String? {
        return nil
    }

}
