//
//  WearCell.swift
//  YiYangCloud
//
//  Created by zhong on 2017/5/8.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import SDWebImage

class WearCell: UITableViewCell {
    
    var model:FamilyListModelContent?{
        didSet{
            self.name.text = model?.nickName
            if model?.sex == "0" {
                self.sex.text = "未知"
            }else if model?.sex == "1" {
                self.sex.text = "男"
            }else {
                self.sex.text = "女"
            }
            self.lastTime.text = model?.lastDate
            self.IDCard.text = model?.memberIdNo
            self.photo.sd_setImage(with: URL.init(string: "http://10.2.20.243:7000/style/headImg/middle.png"))
        }
    }

    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var sex: UILabel!
    
    @IBOutlet weak var IDCard: UILabel!
    
    @IBOutlet weak var lastTime: UILabel!
    
    @IBOutlet weak var selectBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.photo.layer.cornerRadius = 30
        self.photo.layer.masksToBounds = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.cancelSelectBtn(notifi:)), name: Notification.Name(rawValue: "ChangeWear"), object: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func didClickSelBtn(_ sender: UIButton) {
        let notifi = Notification.init(name: Notification.Name(rawValue: "ChangeWear"), object: nil, userInfo: nil)
        NotificationCenter.default.post(notifi)
        sender.isSelected = !sender.isSelected
    }
    
    func cancelSelectBtn(notifi:Notification){
        self.selectBtn.isSelected = false
    }
}
