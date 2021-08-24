//
//  KMReminSetCell.swift
//  YiYangCloud
//
//  Created by 钟晓跃 on 2017/5/24.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

class KMReminSetCell: UITableViewCell {
    
    var titleLabel = UILabel.init()
    
    var detailLabel = UILabel.init()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCell(){
        self.titleLabel.textColor = UIColor(red:0.33, green:0.49, blue:0.96, alpha:1.00)
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(20)
            make.right.equalTo(self.contentView)
            make.top.equalTo(self.contentView).offset(10)
            make.height.equalTo(30)
        }
        
        self.detailLabel.font = UIFont.systemFont(ofSize: 15)
        self.detailLabel.textColor = UIColor.gray
        self.contentView.addSubview(self.detailLabel)
        self.detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(3)
            make.right.equalTo(self.contentView)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
