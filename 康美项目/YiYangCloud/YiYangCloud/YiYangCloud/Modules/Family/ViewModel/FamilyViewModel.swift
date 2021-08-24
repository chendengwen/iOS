//
//  FamilyViewModel.swift
//  YiYangCloud
//
//  Created by gary on 2017/4/25.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import HandyJSON

class FamilyViewModel: KMViewModelProtocol {
    
    // viewController
    let viewController:UIViewController? = nil
    // interactor
    let interactor = FamilyInteractor("", 1)
    
    // dataArray
    lazy var dataArray:Array<FamilyMember> = {
        return []
    }()
    
    /**
     *  加载数据
     */
    func km_loadData(success: KMViewModelProtocol.SuccessBlock, failed: KMViewModelProtocol.FailedBlock) {
        
    }

    /**
     *  将viewModel中的信息传递出去
     *  @param viewModel   viewModel自己
     *  @param infos 描述信息
     */
    func km_viewMOdel<T>(viewModel: T, withInfo info: Dictionary<String, Any>) where T : HandyJSON {
        
    }

    /**
     *  处理ViewModelInfosBlock
     */
    func km_viewModelWithOtherViewModelBlockOfInfos(info: Dictionary<String, Any>) {
        
    }

    /**
     *  传递模型给view
     */
    func km_viewModelWithModelBlock<T>(modelBlock: (T)) where T : HandyJSON {
        
    }

    /**
     *  返回指定viewModel的所引用的控制器
     */
    func km_viewModelWithViewCOntroller() -> UIViewController? {
        return UIViewController()
    }

    
    
    
    
}
