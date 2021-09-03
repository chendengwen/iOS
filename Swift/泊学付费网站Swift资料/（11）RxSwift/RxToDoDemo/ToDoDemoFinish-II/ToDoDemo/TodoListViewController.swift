//
//  ViewController.swift
//  TodoDemo
//
//  Created by Mars on 24/04/2017.
//  Copyright © 2017 Mars. All rights reserved.
//

import UIKit
import RxSwift

class TodoListViewController: UIViewController {
    let todoItems = Variable<[TodoItem]>([])
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
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self

        todoItems.asObservable().subscribe(onNext: { [weak self] todos in
            self?.updateUI(todos: todos)
        }).addDisposableTo(bag)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let naviController = segue.destination as! UINavigationController
        var todoDetailController: TodoDetailViewController!

        todoDetailController = naviController.topViewController as! TodoDetailViewController

        if segue.identifier == "AddTodo" {
            todoDetailController.title = "Add Todo"

            _ = todoDetailController.todo.subscribe(
                onNext: {
                    [weak self] newTodo in
                    self?.todoItems.value.append(newTodo)
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
                        self?.todoItems.value[indexPath.row] = todo
                    },
                    onDisposed: {
                        print("Finish editing a todo.")
                    }
                )
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addTodoItem(_ sender: Any) {
        let todoItem = TodoItem(name: "Todo Demo", isFinished: false)
        todoItems.value.append(todoItem)
    }
    
    @IBAction func saveTodoList(_ sender: Any) {
        saveTodoItems()
    }
    
    @IBAction func clearTodoList(_ sender: Any) {
        todoItems.value.removeAll()
    }
}
