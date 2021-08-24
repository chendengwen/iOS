//
//  BBaseTableViewHeaderFooterView.swift
//  BNOA
//
//  Created by Cary on 2019/11/9.
//  Copyright © 2019 BNIC. All rights reserved.
//

import UIKit
import Reusable

class BBaseTableViewHeaderFooterView: UITableViewHeaderFooterView, Reusable {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configUI() {}
    
}
