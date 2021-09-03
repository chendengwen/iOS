//
//  ViewController.swift
//  TodoDemo
//
//  Created by Mars on 24/04/2017.
//  Copyright © 2017 Mars. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class TodoListViewController: UIViewController {
    let todoItems: BehaviorRelay<[TodoItem]> = BehaviorRelay(value: [])
    let bag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clearTodoBtn: UIButton!
    @IBOutlet weak var addTodo: UIBarButtonItem!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadTodoItems()
    }

    func updateUI(todos: [TodoItem]) {
        clearTodoBtn.isEnabled = !todos.isEmpty
        addTodo.isEnabled = todos.filter { !$0.isFinished }.count < 5
        title = todos.isEmpty ? "Todo" : "\(todos.count) ToDos"

        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        todoItems.subscribe(onNext: { item in
            self.updateUI(todos: self.todoItems.value)
        }).disposed(by: bag)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let naviController = segue.destination as! UINavigationController
        var todoDetailController: TodoDetailViewController!

        todoDetailController = naviController.topViewController as? TodoDetailViewController

        if segue.identifier == "AddTodo" {
            todoDetailController.title = "Add Todo"

            _ = todoDetailController.todo.subscribe( onNext: {
                    [weak self] newTodo in
                    guard let oldArr:[TodoItem] = self?.todoItems.value else {
                        return
                    }
                    let newArr = oldArr + [newTodo]
                    self?.todoItems.accept(newArr)
                },
                onDisposed: {
                    print("Finish adding a new todo.")
                }
            )
        }
        else if segue.identifier == "EditTodo" {
            todoDetailController.title = "Edit todo"

            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                todoDetailController.todoItem = todoItems.value[indexPath.row]

                _ = todoDetailController.todo.subscribe(
                    onNext: { [weak self] todo in
                        guard var newArr:[TodoItem] = self?.todoItems.value else {
                            return
                        }
                        newArr.remove(at: indexPath.row)
                        newArr.insert(todo, at: indexPath.row)
                        self?.todoItems.accept(newArr)
                    },
                    onDisposed: {
                        print("Finish editing a todo.")
                    }
                )
            }
        }
    }

    @IBAction func syncToCloud(_ sender: Any) {
        // Add sync code here
        _ = syncTodoToCloud().subscribe(
            onNext: {
                self.flash(title: "Success",
                    message: "All todos are synced to: \($0)")
            },
            onError: {
                self.flash(title: "Failed",
                    message: "Sync failed due to: \($0.localizedDescription)")
            },
            onDisposed: {
                print("SyncOb disposed")
            }
        )

        print("RC: \(RxSwift.Resources.total)")
    }
    
    @IBAction func saveTodoList(_ sender: Any) {
        _ = saveTodoItems().subscribe(
            onError: { [weak self] error in
                self?.flash(title: "Success",
                            message: error.localizedDescription)
            },
            onCompleted: { [weak self] in
                self?.flash(title: "Success",
                            message: "All Todos are saved on your phone.")
            },
            onDisposed: { print("SaveOb disposed") }
        )
        
        print("RC: \(RxSwift.Resources.total)")
    }
    
    @IBAction func clearTodoList(_ sender: Any) {
        todoItems.accept([])
    }
}
