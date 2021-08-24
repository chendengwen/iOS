//
//  API.swift
//  BNOA
//
//  Created by Cary on 2019/11/8.
//  Copyright © 2019 BNIC. All rights reserved.
//

import Moya
import HandyJSON
import SVProgressHUD

let LoadingPlugin = NetworkActivityPlugin.init { (type, target) in
    switch type {
    case .began:
        SVProgressHUD.show()
    case .ended:
        SVProgressHUD.dismiss()
    }
}

let timeoutClosure = {(endpoint: Endpoint, closure: MoyaProvider<BNAPI>.RequestResultClosure) -> Void in
    if var urlRequest = try? endpoint.urlRequest() {
        closure(.success(urlRequest))
    } else {
        closure(.failure(MoyaError.requestMapping(endpoint.url)))
    }
}

let ApiProvider = MoyaProvider<BNAPI>(requestClosure: timeoutClosure)
let ApiLoadingProvider = MoyaProvider<BNAPI>(requestClosure: timeoutClosure, plugins: [LoadingPlugin])

enum BNAPI {
    case regist(phoneNO: String, codeNO: String)
    case login(username: String, password: String)
    case home(id: Int)
    case newsList(pageIndex: Int)
    case bannerList
}

extension BNAPI: TargetType {
    
    var baseURL: URL {
        return URL.init(string: "https://f67aa692-bbed-4914-babe-41b90609762d.mock.pstmn.io")!
    }
    
    var path: String {
        switch self {
        case .regist: return "regist"
        case .login:    return "login"
        case .home: return "home"
        case .bannerList: return "bannerList"
        case .newsList: return "newsList"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .regist:
            return .post
        default:
            return .get
        }
    }
    
    var task: Task {
        var parmeters: [String : Any] = [:]
        switch self {
        case .regist(let phoneNO, let codeNO):
            parmeters["phoneNO"] = phoneNO
            parmeters["codeNO"] = codeNO
        case .login(let username, let password):
            parmeters["username"] = username
            parmeters["password"] = password
        case .home(let uid):
            parmeters["uid"] = uid
        case .newsList(let pageIndex):
            parmeters["pageIndex"] = pageIndex
        default:
            return .requestPlain
        }
        
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
    }
    
    var sampleData: Data { return "".data(using: String.Encoding.utf8)! }
    var headers: [String : String]? { return nil }
}

extension Response {
    func mapModel<T: HandyJSON>(_ type: T.Type) throws -> T {
        let jsonString = String(data: data, encoding: .utf8)
        guard let model = JSONDeserializer<T>.deserializeFrom(json: jsonString) else {
            throw MoyaError.jsonMapping(self)
        }
        return model
    }
}

extension MoyaProvider {
    @discardableResult
    open func request<T: HandyJSON>(_ target: Target, model: T.Type, completion: ((_ returnData: T?) -> Void)?) -> Cancellable? {
        return request(target, completion: { (result) in
            guard let completion = completion else {return}
            guard let responseData = try? result.value?.mapModel(ResponseData<T>.self) else {
                completion(nil)
                return
            }
            completion(responseData.data?.returnData)
        })
    }
}

extension Array: HandyJSON{}

struct ReturnData<T: HandyJSON>: HandyJSON {
    var message:String?
    var returnData: T?
    var stateCode: Int = 0
}

struct ResponseData<T: HandyJSON>: HandyJSON {
    var code: Int = 0
    var data: ReturnData<T>?
}
