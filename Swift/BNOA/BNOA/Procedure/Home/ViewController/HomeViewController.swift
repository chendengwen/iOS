//
//  HomeViewController.swift
//  BNOA
//
//  Created by Cary on 2019/11/8.
//  Copyright © 2019 BNIC. All rights reserved.
//

import UIKit
import SDCycleScrollView

class HomeViewController: BBaseViewController {
    
    private lazy var banner: SDCycleScrollView = {
        let sd = SDCycleScrollView()
        sd.backgroundColor = UIColor.green
        sd.autoScrollTimeInterval = 5
        sd.placeholderImage = UIImage.init(named: "normal_placeholder")
        sd.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        sd.pageControlBottomOffset = 20
        sd.clickItemOperationBlock = didSelectBanner(index:)
        
        return sd
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "首页"
        
        loadData()
    }
    
    override func configUI() {
        view.addSubview(banner)
        banner.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(120)
        }
    }
    
    private func didSelectBanner(index: NSInteger) {
        
    }
    
    private func loadData() {
        ApiLoadingProvider.request(.newsList(pageIndex: 0), model: NewsModel.self) {[weak self] (returnData) in

            self?.banner.imageURLStringsGroup = ["https://thumbs.dreamstime.com/x/u52a8-/u7247/u5728a-f/u4e0a/u5199/u5b57-41195691.jpg", "https://gss0.baidu.com/9vo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/8601a18b87d6277fe72e9fb82d381f30e924fc76.jpg"]
        }
    }

}
