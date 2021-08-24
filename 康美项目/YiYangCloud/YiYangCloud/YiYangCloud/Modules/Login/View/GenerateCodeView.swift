//
//  GenerateCodeView.swift
//  YiYangCloud
//
//  Created by gary on 2017/4/24.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

class GenerateCodeView: UIView {

    //随机产生颜色
    var randomColor = (Float)(arc4random()%255)/100.0
    // 验证码位数
    var codeNumber:Int = 4
    var codeString:String = ""
    //随机验证码数据源
    var dataArray:[String] = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        self.changeBgColor()
        self.CreateGenerateCodeAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //改变背景颜色
    func changeBgColor() -> Void {
        self.backgroundColor = self.generateColor()
    }
    
    // 随机验证码的view实现
    func CreateGenerateCodeAction() -> Void {
        codeString = ""
        for _ in 0...codeNumber-1 {
            var d = Int(arc4random())%dataArray.count-1
            if (d <= 0) {
                d = 0
            }else if (d >= dataArray.count) {
                d = dataArray.count - 1
            }
            print("---totalcount %d currentCount %d",dataArray.count, d)
            codeString = codeString.appending(dataArray[d]
            )
        }
        self.setNeedsDisplay()
    }
    
    // 随机颜色
    func generateColor() -> UIColor {
        return UIColor.init(colorLiteralRed: (Float)(arc4random()%256)/256.0, green: (Float)(arc4random()%256)/256.0, blue: (Float)(arc4random()%256)/256.0, alpha: 1.0)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.changeBgColor()
        self.CreateGenerateCodeAction()
    }
    
    // 把随机码画上去
    override func draw(_ rect: CGRect) {
        
        if codeString.isEmpty {
            return;
        }
        
        self.backgroundColor = self.generateColor()
        
        let textString:String = codeString
        let charSize = textString.substring(to: textString.startIndex).size(attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 16)])
        
        let width = rect.size.width/CGFloat(codeNumber) - charSize.width - 5;
        let hight = rect.size.height - charSize.height;
        
        var mypoint:CGPoint
        // 计算每个字符
        
        var point_x:CGFloat
        var point_y:CGFloat
        
        let intWidth = UInt32(Float(width))
        let intHight = UInt32(Float(hight))
        
        for i in 0...textString.characters.count-1 {
            let c:CGFloat = CGFloat(i)
            let myIn:Int = Int(i)
            point_x = (CGFloat)(arc4random()%intWidth) + rect.size.width/(CGFloat)(textString.characters.count) * c
            point_y = (CGFloat)(arc4random()%intHight)
            mypoint = CGPoint(x:point_x, y:point_y)
            
            let charStr = textString[textString.characters.index(textString.startIndex, offsetBy: myIn)]
            
            let bb:String = ""
            let t = bb + String(charStr)
            t.draw(at: mypoint,withAttributes:([NSFontAttributeName : UIFont.systemFont(ofSize: 16)]))
        }
        
        
        let context = UIGraphicsGetCurrentContext()
        context!.setLineWidth(1)
        var px:CGFloat = 0.0
        var py:CGFloat = 0.0
        for _ in 0...5 {
            context!.setStrokeColor(self.generateColor().cgColor)
            px = CGFloat(arc4random()%UInt32(Float(rect.size.width)))
            py = CGFloat(arc4random()%UInt32(Float(rect.size.height)))
            context?.move(to: CGPoint.init(x: px, y: py))
            px = CGFloat(arc4random()%UInt32(Float(rect.size.width)))
            py = CGFloat(arc4random()%UInt32(Float(rect.size.height)))
            context?.addLine(to: CGPoint.init(x: px, y: py))
            context!.strokePath()
        }
    }

}
