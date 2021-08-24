//
//  DeviceManageView.swift
//  FuncGroup
//
//  Created by gary on 2017/2/10.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

@IBDesignable
class DeviceManageView: UIView {
    
    var delegate:Any?
    
    @IBInspectable var title:String! {
        willSet {
            titleLabel.text =  (newValue);
        }
    }
    @IBInspectable var MAC:String! = String.init() {
        willSet {
            MACLabel.text = (newValue);
            MACLabel.font = UIFont.systemFont(ofSize: 14)
            MACLabel.textColor = Resource.lightGrayColor()
        }
    }
    @IBInspectable var time:String! = String.init() {
        willSet {
            timeLabel.text = (newValue);
            timeLabel.font = UIFont.systemFont(ofSize: 14)
            timeLabel.textColor = Resource.lightGrayColor()
        }
    }
    
    @IBInspectable var image:String! = String.init() {
        willSet {
            titleLabel.text = (newValue);
        }
    }
    @IBInspectable var bandImage:String! {
        willSet {
            bandButton.setImage(UIImage.init(named: (newValue)), for: .normal)
        }
    }
    
    let imageView:UIImageView = UIImageView.init()
    let bandButton:UIButton = UIButton.init(frame: CGRect(x:120,y:20,width:30,height:30))
    let titleLabel:UILabel = UILabel.init(frame: CGRect(x:100,y:20,width:120,height:21))
    let MACLabel:UILabel = UILabel.init(frame: CGRect(x:100,y:50,width:120,height:21))
    let timeLabel:UILabel = UILabel.init(frame: CGRect(x:100,y:70,width:120,height:21))

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        
        if image != nil {
            let img = UIImage.init(named: image)
            imageView.image = img
            imageView.frame =  CGRect(x:30,y:(self.frame.size.height - (img?.size.height)!)/2,width:(img?.size.width)!
                ,height:(img?.size.height)!)
            if !self.subviews .contains(self.imageView) {
                self.addSubview(imageView)
            }
        }else {
            imageView.image = nil
        }
        
        if bandImage != nil {
            bandButton.setImage(UIImage.init(named: bandImage), for: .normal)
            if !self.subviews .contains(self.bandButton) {
                self.addSubview(bandButton)
                bandButton.addTarget(delegate, action: Selector(("deviceLockButtonClick:")), for: .touchUpInside)
            }
        }else {
            bandButton.setImage(nil, for: .normal)
        }
        
        
        titleLabel.text = title;
        MACLabel.text = MAC;
        timeLabel.text = time;
        if !self.subviews .contains(self.titleLabel) {
            self.addSubview(titleLabel)
        }
        if !self.subviews .contains(self.MACLabel) {
            self.addSubview(MACLabel)
        }
        if !self.subviews .contains(self.timeLabel) {
            self.addSubview(timeLabel)
        }
        
    }

}
