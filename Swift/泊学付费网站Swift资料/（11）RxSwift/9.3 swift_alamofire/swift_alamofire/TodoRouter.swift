//
//  TodoRouter.swift
//  swift_alamofire
//
//  Created by gary on 2021/9/1.
//

import Foundation
import Alamofire

enum TodoRouter {
    static let baseURL: String = "https://jsonplaceholder.typicode.com/"
    
    case get(Int?) //为 nil 时，表示要获取所有todo的列表；为 Int 时，表示要获取某一个具体的todo信息
}

extension TodoRouter: URLRequestConvertible {
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .get:
                return .get
            
            }
        }
        
        var params: [String: Any]? {
            switch self {
            case .get:
                return nil
            
            }
        }
        
        var url: URL {
            var relativeUrl: String = "todos"
            
            switch self {
            case .get(let todoId):
                if todoId != nil {
                    relativeUrl = "todos\(todoId!)"
                }
            
            }
            
            let url = URL(string: TodoRouter.baseURL)!.appendingPathComponent(relativeUrl)
            return url
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        let encoding = JSONEncoding.default
        
        return try encoding.encode(request, with: params)
    }
}
