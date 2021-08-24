//
//  HealthItemCell.swift
//  YiYangCloud
//
//  Created by gary on 2017/4/13.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

class HealthItemCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        let queue = DispatchQueue.main
//        dispatch_sync(DispatchQueue.global(), { () -> Void in
//            //code here
////            println(NSThread.currentThread())
//        })
        queue.async {
            
        }
    }
    
}
