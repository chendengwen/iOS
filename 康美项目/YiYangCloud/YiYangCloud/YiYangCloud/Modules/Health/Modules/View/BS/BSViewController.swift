//
//  BSViewController.swift
//  YiYangCloud
//
//  Created by gary on 2017/4/20.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

class BSViewController: UIViewController {
    
    @IBOutlet weak var cycleGraphicsView: KMCycleGraphicsView!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var energyLabel: UILabel!
    let manage = HealthKitManage.shared
    static var isAuthorize:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "计步"
        if BSViewController.isAuthorize {
            self.refreshUI()
        }else{
            self.manage.authorizeHealthKit { [unowned self](success, error) in
                if success {
                    self.refreshUI()
                    BSViewController.isAuthorize = true
                }
            }
        }
    }
}

extension BSViewController {
    func refreshUI() {
        //刷新步数
        self.manage.getStepCount(result: { [unowned self](value, error) in
            DispatchQueue.main.async(execute: {
                self.cycleGraphicsView.reloadGraphics(UIColorFromRGBA(0x7fc156), toValue: CGFloat(value), totalValue: CGFloat(value))
            })
        })
        //刷新公里 卡路里
        self.manage.getDistance(result: { [unowned self](value, error) in
            DispatchQueue.main.async(execute: {
                self.distanceLabel.text = String.init(format: "%.2lf 公里", value)
                self.energyLabel.text = String.init(format: "%.2lf 卡", value/1.6 * 84.0 )
            })
            
        })
    }
}
