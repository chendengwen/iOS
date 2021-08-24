//
//  FamilyMemberCell.swift
//  YiYangCloud
//
//  Created by gary on 2017/4/13.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import AlamofireImage

class FamilyMemberCell: UITableViewCell {

    required init?(coder aDecoder: NSCoder) {
        self.model = FamilyMember()
        super.init(coder: aDecoder)
    }
    
    var model:FamilyMember {
        // 在swift 中get,set被称之为“计算属性”，它用来间接获取/改变其他属性的值
//        get {
//            return self.model
//        }
//        set(newVal) {
//            model =  newVal
//        }
        didSet {
            headImg.af_setImage(withURL: URL.init(string: APIs.API_File_Type.getHeadImg.getAPI() + (self.model.memberPicUrl ?? ""))!)
            relationShipLB.text = self.model.relationShip ?? " "
            healthLB.text = self.model.title ?? " "
            
            // 处理字符串里的数字
            recentStatusLB.attributedText = NSAttributedString.attributedString((self.model.remind)!)
            
            locationBtn.isSelected = arc4random()%2 == 1
            telephoneBtn.isSelected = arc4random()%2 == 1
        }
    }
    
    var locationBlock:() -> Void = {}
    var telephoneBlock:(String?) -> Void = { phoneNum in }
    
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var relationShipLB: UILabel!
    @IBOutlet weak var healthLB: UILabel!
    @IBOutlet weak var recentStatusLB: UILabel!
    
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var telephoneBtn: UIButton!
    @IBOutlet weak var rankingBtn: UIButton!
    @IBOutlet weak var rankingLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func locationClick(_ sender: Any) {
        locationBlock()
    }
    
    @IBAction func telephoneClick(_ sender: Any) {
        telephoneBlock(self.model.phone ?? "")
    }
   
}

extension NSAttributedString {
    class func attributedString(_ string:String) -> NSAttributedString {
        // 1.记录数字位置，然后移除数字
        // 2.内容转为attributedString以后再插入数字
        
        guard string.characters.count <= 0 else {
            var textCheckingResult:[NSTextCheckingResult] = Array()
            do {
                // - 1.1、创建规则
                let pattern = "[0-9]"
                // - 1.2、创建正则表达式对象
                let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
                // - 1.3、开始匹配
                let res:[NSTextCheckingResult] = regex.matches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, string.characters.count))

                // 输出结果
//                for checkingRes in res {
//                    print((string as NSString).substring(with: checkingRes.range))
//                    
//                }
                
                textCheckingResult = res
            }
            catch {
                print(error)
            }
            
            let mutableAttributedString = NSMutableAttributedString.init(string: string, attributes: [NSForegroundColorAttributeName:UIColorFromRGBA(0x999999)])
            
            for checkingRes in textCheckingResult {
                let attributedString = NSAttributedString.init(string: (string as NSString).substring(with: checkingRes.range), attributes:[NSForegroundColorAttributeName:UIColorFromRGBA(0xf88121)] )
                mutableAttributedString.replaceCharacters(in: checkingRes.range, with: attributedString)
            }
            
            return mutableAttributedString
        }
        
        
        return NSAttributedString.init(string: "");
    }
}
