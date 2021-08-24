//
//  FamilyPresenter.swift
//  YiYangCloud
//
//  Created by gary on 2017/4/25.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import HandyJSON

struct StoryBoardNames_Family {
    
    static let FamilyGroup = StoryBoardName<String>(rawValue:"Family")
    static let FamilyDetail = StoryBoardName<String>(rawValue:"FamilyDetail")
    static let LocationRecord = StoryBoardName<String>(rawValue:"LocationRecord")
    static let SearchMember = StoryBoardName<String>(rawValue:"SearchMember")
    
}


protocol KM_bindViewModel {
    
    static func km_bindingViewModel<T: HandyJSON>(_ viewModel:T)
    
}


class FamilyPresenter: BasePresenter {
    
//    override func getInterface() -> UIViewController {
//        
//        
//    }


}
