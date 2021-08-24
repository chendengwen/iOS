//
//  BluetoothCell.swift
//  YiYangCloud
//
//  Created by zhong on 2017/4/25.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

protocol BluetoothCellDelegate: class {
    func refreshBluetooth(type: String)
}

class BluetoothCell: UITableViewCell {
    
    var icon = UIImageView.init()
    
    var title = UILabel.init()
    
    var MAC = UILabel.init()
    
    weak var delegate: BluetoothCellDelegate?
    
    var model:BluetoothDeviceModel?{
        didSet{
            self.title.text = model?.deviceName
            self.icon.image = UIImage.init(named: (model?.deviceIcon)!)
            self.MAC.text = model?.MAC
            
        }
    }
    
    
    lazy var refreshBtn:UIButton = {
        let button = UIButton.init()
        button.setImage(UIImage.init(named: "shuaxing"), for: .normal)
        button.setImage(UIImage.init(named: "shuaxing2"), for: .highlighted)
        button.addTarget(self, action:#selector(self.didClickRefresh(sender:)), for: .touchUpInside)
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

extension BluetoothCell {
    func setupUI () {
        self.selectionStyle = .none;
        
        addSubview(icon)
        addSubview(title)
        addSubview(MAC)
        addSubview(refreshBtn)
        
        title.textColor = UIColorFromRGB_Z(102,102,102)
        MAC.textColor = UIColorFromRGB_Z(153,153,153)

        
        icon.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.centerY.equalTo(self)
            make.width.height.equalTo(40)
        }
        
        title.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(20)
            make.centerY.equalTo(icon)
        }
        
        MAC.snp.makeConstraints { (make) in
            make.left.equalTo(title.snp.right).offset(15)
            make.centerY.equalTo(icon)
        }
        
        refreshBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(icon)
            make.right.equalTo(self).offset(-20)
            make.width.height.equalTo(20)
        }
        
    }
}

extension BluetoothCell {
    func didClickRefresh(sender:UIButton) {
        self.delegate?.refreshBluetooth(type: (self.model?.deviceName)!)
    }
}
