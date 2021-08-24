//
//  KMViewController.swift
//  YiYangCloud
//
//  Created by gary on 2017/5/22.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

private var kInteractorKey: String = "interactorKey"
public extension UIViewController {

    var interactor: BaseInteractor? {
        get { return (objc_getAssociatedObject(self, &kInteractorKey) as? BaseInteractor) }
        set(newValue) {
            objc_setAssociatedObject(self, &kInteractorKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
}

