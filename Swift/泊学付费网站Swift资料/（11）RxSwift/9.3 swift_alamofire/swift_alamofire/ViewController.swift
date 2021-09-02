//
//  ViewController.swift
//  swift_alamofire
//
//  Created by gary on 2021/9/1.
//

import UIKit
import Alamofire
import RxSwift

class ViewController: UIViewController {
    
    var todoList = [Todo]()
    var bag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        
        let todoId:Int? = nil
        Observable.of(todoId)
        .map { tid in   // map 后转换为 Observable<TodoRouter>
            return TodoRouter.get(tid)
        }.flatMap { router in    // flatMap 会把原序列中的每一个事件，变成一个新的 Observable
            return Todo.getList(from: router)
        }.subscribe(onNext: { (todos:[[String : Any]]) in
            self.todoList = todos.compactMap{ Todo(json: $0) }
            self.tableView.reloadData()
        }, onError: { error in
            print(error.localizedDescription)
        }).disposed(by: bag)
        
        //传统习惯写法
//        Todo.getList(from: TodoRouter.get(nil))
//        .subscribe(onNext: { (todos:[[String : Any]]) in
//            self.todoList = todos.compactMap{ Todo(json: $0) }
//            self.tableView.reloadData()
//        }, onError: { error in
//            print(error.localizedDescription)
//        }).disposed(by: bag)
        
    }
}

extension ViewController: UITableViewDataSource {
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

