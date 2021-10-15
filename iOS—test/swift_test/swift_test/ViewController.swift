//
//  ViewController.swift
//  Swift_test
//
//  Created by gary on 2021/7/28.
//

import UIKit

class User: NSObject {
    var name:String
    var age:Int
    var address:String
    
    init(name:String, age:Int, address:String) {
        self.name = name
        self.age = age
        self.address = address
    }
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let point: Drawable = Point(x: 1, y: 1)
        point.draw()
        let line: Drawable = Line(x1: 2, y1: 2, x2: 6, y2: 6)
        line.draw()
    }

}


protocol Drawable {
    func draw()
}

struct Point: Drawable {
    var x: Int
    var y: Int
    func draw() {
        print("A point at (x: \(x), y: \(y))")
    }
}

struct Line: Drawable {
    var x1: Int // From position
    var y1: Int
    var x2: Int // To position
    var y2: Int
    func draw() {
        print("A line from: (x: \(x1), y: \(y1)) " + "to (x: \(x1), y: \(y2))")
    }
}
