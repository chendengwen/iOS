//
//  GitHubDataModel.swift
//  RxSwiftDemo
//
//  Created by gary on 2021/9/2.
//  Copyright © 2021 LXF. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

enum GetTodoListError: Error {
    case cannotConvertServerResponse
}

class Todo {
    var id: UInt?
    var title: String
    var completed: Bool
    
    init(id: UInt, title: String, completed: Bool) {
        self.id = id
        self.title = title
        self.completed = completed
    }
    
    required init?(json: [String: Any]) {
        guard let todoId = json["id"] as? UInt,
            let title = json["title"] as? String,
            let completed = json["completed"] as? Bool else {
            return nil
        }
        self.id = todoId
        self.title = title
        self.completed = completed
    }
}

extension Todo {
    class func getList(from router: TodoRouter) -> Observable<[[String: Any]]> {
        return Observable.create { (observer) -> Disposable in
            let request = Alamofire.request(TodoRouter.get(nil)).responseJSON { (response) in
                guard response.result.error == nil else {
                    observer.on(.error(response.result.error!))
                    return
                }
                
                guard let todos = response.result.value as? [[String: Any]] else {
                    observer.on(.error(GetTodoListError.cannotConvertServerResponse))
                    return
                }
                
                observer.on(.next(todos))
                observer.onCompleted()
            }
            
            return Disposables.create{
                request.cancel()
            }
        }
    }
}
