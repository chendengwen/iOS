//
//  BBaseViewController.swift
//  BNOA
//
//  Created by Cary on 2019/11/9.
//  Copyright © 2019 BNIC. All rights reserved.
//

import UIKit
import SnapKit
import Reusable
import Kingfisher

class BBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.background
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavigationBar()
    }
    

    func configUI() {}

    func configNavigationBar() {
        guard let nav = navigationController else { return }
        if nav.visibleViewController == self {
            nav.barStyle(.theme)
            nav.disablePopGesture = false
            nav.setNavigationBarHidden(false, animated: true)
            
            if nav.viewControllers.count > 1 {
                let spaceBar = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
                spaceBar.width = -15
                let buttonBar = UIBarButtonItem(image: UIImage(named: "nav_back_white"), style: .plain, target: self, action: #selector(popBack))
                navigationItem.leftBarButtonItems = [spaceBar,buttonBar]
            }
        }
    }
    
    @objc func popBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension BBaseViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
