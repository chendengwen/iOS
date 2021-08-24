//
//  DeviceCell.swift
//  YiYangCloud
//
//  Created by zhong on 2017/4/25.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

protocol DeviceCellDelegate: class {
    func pushMaintainVC(cell: DeviceCell)
}

class DeviceCell: UITableViewCell {
    
    weak var delegate: DeviceCellDelegate?
    
    var model:WearDataDevice?{
        didSet{
            if model?.type != nil {
                self.type.text = model!.type
            }
            
        }
    }
    
    
    var icon = UIImageView.init()
    
    var title = UILabel.init()
    
    var type = UILabel.init()
    
    lazy var maintainBtn:UIButton = {
        let button = UIButton.init()
        button.setTitle("维护", for: .normal)
        button.setBackgroundImage(UIImage.init(named: "device_botton"), for: .normal)
        button.addTarget(self, action:#selector(self.didClickMaintain(sender:)), for: .touchUpInside)
        button.setTitleColor(UIColorFromRGB_Z(255, 255, 255), for: .normal)
        return button
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

extension DeviceCell {
    func setupUI () {
        self.selectionStyle = .none;
        
        addSubview(icon)
        addSubview(title)
        addSubview(type)
        addSubview(maintainBtn)
        
        title.textColor = UIColorFromRGB_Z(102,102,102)
        type.textColor = UIColorFromRGB_Z(153,153,153)
        title.text = "爸爸"
        type.text = "KM8020"
        
        icon.image = UIImage.init(named: "surface")
        
        icon.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.centerY.equalTo(self)
            make.width.height.equalTo(40)
        }
        
        title.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(20)
            make.centerY.equalTo(icon)
        }
        
        type.snp.makeConstraints { (make) in
            make.left.equalTo(title.snp.right).offset(15)
            make.centerY.equalTo(icon)
        }
        
        maintainBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(icon)
            make.right.equalTo(self).offset(-20)
            make.width.equalTo(60)
            make.height.equalTo(28)
        }
        
    }
}

extension DeviceCell {
    func didClickMaintain(sender:UIButton) {
        print("didClickMaintain")
        if self.delegate != nil {
            self.delegate?.pushMaintainVC(cell: self)
        }
    }
}
