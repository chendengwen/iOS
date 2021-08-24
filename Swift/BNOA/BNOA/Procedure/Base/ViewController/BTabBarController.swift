//
//  BTabBarController.swift
//  BNOA
//
//  Created by Cary on 2019/11/9.
//  Copyright © 2019 BNIC. All rights reserved.
//

import UIKit

class BTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.isTranslucent = false
        
        ///首页
        addChildViewController(HomeViewController(),
                               title: "首页",
                               image: UIImage(named: "tab_home"),
                               seletedImage: UIImage(named: "tab_home_S"))
        
        ///个人中心
        addChildViewController(MineViewController(),
                               title: "我的",
                               image: UIImage(named: "tab_mine"),
                               seletedImage: UIImage(named: "tab_mine_S"))
    }
    
    func addChildViewController(_ childController:UIViewController, title:String, image:UIImage?, seletedImage:UIImage?) {
        childController.title = title
        childController.tabBarItem = UITabBarItem.init(title: nil, image: image?.withRenderingMode(.alwaysOriginal), selectedImage: seletedImage?.withRenderingMode(.alwaysOriginal))
        if UIDevice.current.userInterfaceIdiom == .phone {
            childController.tabBarItem.imageInsets = UIEdgeInsets.init(top: 6, left: 0, bottom: -6, right: 0)
        }
        addChild(BNavigationController(rootViewController: childController))
    }

}
