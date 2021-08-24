//
//  SearchMemberCell.swift
//  YiYangCloud
//
//  Created by Cary on 2017/5/15.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import AlamofireImage

class SearchMemberCell: UITableViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        self.model = SearchMemberModel()
        super.init(coder: aDecoder)
    }

    @IBOutlet weak var headImg: UIImageView!
    
    @IBOutlet weak var nameLab: UILabel!
    
    @IBOutlet weak var genderLab: UILabel!
    
    @IBOutlet weak var cardIDLab: UILabel!
    
    @IBOutlet weak var lastCheckLab: UILabel!
    
    @IBOutlet weak var careBtn: UIButton!
    
    var model:SearchMemberModel {
        didSet {
            headImg.af_setImage(withURL: URL.init(string: APIs.API_File_Type.getHeadImg.getAPI() + (self.model.memberPicUrl ?? ""))!)
            nameLab.text = self.model.memberRealName
            genderLab.text = self.model.memberSex == 1 ? "男" : "女"
            cardIDLab.text = self.model.memberIdNo
            lastCheckLab.text = self.model.lastDate
        }
    }
    
    var careBlock:(_ uid:String?) -> Void = {uid in}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func careButtonClick(_ sender: Any) {
        careBlock(self.model.memberId!)
    }
    
    
}
