//
//  BTableViewCell.swift
//  BNOA
//
//  Created by Cary on 2019/11/9.
//  Copyright © 2019 BNIC. All rights reserved.
//

import UIKit
import Reusable

class BBaseTableViewCell: UITableViewCell, Reusable {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configUI() {}

}
