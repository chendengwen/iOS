//
//  NetworkViewController.swift
//  RxSwiftDemo
//
//  Created by gary on 2021/9/2.
//  Copyright © 2021 LXF. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift

class NetworkViewController: UIViewController {
    
    @IBOutlet weak var mTableView: UITableView!
    let reuserId = "TodoItem"
    var todoList = [Todo]()
    var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Alamofire示例"
        
        self.mTableView.register(UITableViewCell.self, forCellReuseIdentifier: reuserId)
        mTableView.dataSource = self

        let todoId:Int? = nil //请求参数
        Observable.of(todoId)
        .map { tid in   // map 后转换为 Observable<TodoRouter>
            return TodoRouter.get(tid)
        }.flatMap { router in    // flatMap 会把原序列中的每一个事件，变成一个新的 Observable
            return Todo.getList(from: router)
        }.subscribe(onNext: { (todos:[[String : Any]]) in
            self.todoList = todos.compactMap{ Todo(json: $0) }
            self.mTableView.reloadData()
        }, onError: { error in
            print(error.localizedDescription)
        }).disposed(by: bag)
        
        // 传统习惯写法
//        Todo.getList(from: TodoRouter.get(nil))
//        .subscribe(onNext: { (todos:[[String : Any]]) in
//            self.todoList = todos.compactMap{ Todo(json: $0) }
//            self.mTableView.reloadData()
//        }, onError: { error in
//            print(error.localizedDescription)
//        }).disposed(by: bag)
        
    }
}

extension NetworkViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.todoList.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "TodoItem", for: indexPath)
        let todo = todoList[indexPath.row]
        
        cell.textLabel?.text = todo.title
        
        return cell
    }
}
