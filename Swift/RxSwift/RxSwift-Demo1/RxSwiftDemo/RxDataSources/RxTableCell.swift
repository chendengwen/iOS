//
//  RxCellView.swift
//  Rxswift_test
//
//  Created by 陈登文 on 2021/9/1.
//

import UIKit

class RxTableCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        print(#function)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
