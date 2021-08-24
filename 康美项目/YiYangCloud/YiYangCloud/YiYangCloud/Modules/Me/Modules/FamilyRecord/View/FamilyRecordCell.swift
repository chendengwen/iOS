//
//  FamilyRecordCell.swift
//  YiYangCloud
//
//  Created by Cary on 2017/5/12.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import AlamofireImage

class FamilyRecordCell: UITableViewCell {

    required init?(coder aDecoder: NSCoder) {
        self.model = FamilyRecordModel()
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var headImg: UIImageView!
    
    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var genderL: UILabel!
    
    @IBOutlet weak var phoneNumL: UILabel!
    
    @IBOutlet weak var agreenBtn: UIButton!
        
    var model:FamilyRecordModel {
        didSet {
//            headImg.af_setImage(withURL: URL.init(string: APIs.API_File_Type.getHeadImg.getAPI() + (self.model.memberPicUrl ?? ""))!)
            nameL.text = self.model.nickName ?? ""
            genderL.text = self.model.sex == 1 ? "男" : "女"
            phoneNumL.text = self.model.phone
        }
    }
   
    var agreenBlock:(Void) -> Void = {}
    
    @IBAction func agreenButtonClick(_ sender: Any) { agreenBlock() }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
