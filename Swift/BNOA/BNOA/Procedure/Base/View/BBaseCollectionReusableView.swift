//
//  BBaseCollectionReusableView.swift
//  BNOA
//
//  Created by Cary on 2019/11/9.
//  Copyright © 2019 BNIC. All rights reserved.
//

import UIKit
import Reusable

class BBaseCollectionReusableView: UICollectionReusableView, Reusable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configUI() {}
}
