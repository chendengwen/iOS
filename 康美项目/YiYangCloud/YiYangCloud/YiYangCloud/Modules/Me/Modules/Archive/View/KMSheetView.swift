//
//  KMSheetView.swift
//  YiYangCloud
//
//  Created by Cary on 2017/5/10.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

class KMSheetView: UIView {
    
    fileprivate let headHeight:CGFloat = 40.0   // 顶部按钮区高度
    
    var titleLab = UILabel.init()
    var tableView = UITableView.init()
    
    var viewheight: CGFloat = 0.0
    var kmMaskView:KMMaskView = KMMaskView()
    
    var dataArray:[String] {
        willSet {
            viewheight = CGFloat(newValue.count*50) + 40.0
        }
        didSet {
            self.frame = CGRect.init(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: viewheight)
        }
    }
    
    var finishBlock:(String,Int) -> ()
    
    
    init() {
        dataArray = Array()
        finishBlock = { (text:String, index:Int) in }
        
        super.init(frame: CGRect.init(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: 140.0))
        layoutViews()
    }
    
    override init(frame: CGRect) {
        dataArray = Array()
        finishBlock = { (text:String, index:Int) in }
        
        super.init(frame: frame)
        layoutViews()
    }
    
    fileprivate func layoutViews() {
        
        // 顶部区域
        func layoutHead() {
            let headBG = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: self.headHeight))
            headBG.backgroundColor = UIColorFromRGBA(0xf8f8f8)
            self.addSubview(headBG)
            
            let titleLabWidth:CGFloat = 100.0 , titleLabHeight:CGFloat = 16.0
            titleLab.frame = CGRect.init(x:0, y:0, width: titleLabWidth, height: titleLabHeight)
            titleLab.center = headBG.center
            titleLab.textAlignment = .center
            titleLab.font = UIFont.systemFont(ofSize: 14.0)
            titleLab.text = "选择"
            titleLab.textColor = UIColorFromRGBA(0x666666)
            
            let line = UIView.init(frame: CGRect.init(x: 0, y: headBG.frame.height - 0.5, width: headBG.frame.width, height: 0.5))
            line.backgroundColor = UIColorFromRGBA(0xE3E3E3)
            headBG.addSubview(line)
            
            let btnWidth:CGFloat = 40.0 , btnHeight:CGFloat = 30.0
            let cancelBtn = UIButton.init(frame: CGRect.init(x: 15, y: (headBG.frame.height - btnHeight)/2, width: btnWidth, height: btnHeight))
            let finishBtn = UIButton.init(frame: CGRect.init(x: headBG.frame.width - 15 - btnWidth, y: (headBG.frame.height - btnHeight)/2, width: btnWidth, height: btnHeight))
            
            cancelBtn.setTitle("取消", for: .normal)
            cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
            cancelBtn.setTitleColor(UIColorFromRGBA(0x007AFF), for: .normal)
            cancelBtn.addTarget(self, action: #selector(KMSheetView.cancel), for: .touchUpInside)
            
            finishBtn.setTitle("完成", for: .normal)
            finishBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
            finishBtn.setTitleColor(UIColorFromRGBA(0x007AFF), for: .normal)
            finishBtn.addTarget(self, action: #selector(KMSheetView.finish), for: .touchUpInside)
            
            headBG.addSubview(titleLab)
            headBG.addSubview(cancelBtn)
            headBG.addSubview(finishBtn)
        }
        
        // 内容区tableView
        func layoutTableView() {
            
            let tableView = UITableView.init(frame: CGRect.init(x: 0, y: headHeight, width: SCREENWIDTH, height: self.frame.height - headHeight), style: .plain)
            tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20)
            tableView.delegate = self
            tableView.dataSource = self
            
            self.addSubview(tableView)
        }
        
        layoutHead()
        layoutTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        dataArray = Array()
        finishBlock = { (text:String, index:Int) in }
        
        super.init(coder: aDecoder)
        layoutViews()
    }
    
    func cancel(_ sender: Any) {
        dismiss()
    }
    
    func finish(_ sender: Any) {
        dismiss()
    }
    
    
    
    override func draw(_ rect: CGRect) {
        // 修改self的frame以后手动修改tableView的高度
        tableView.frame = CGRect.init(x: 0, y: self.headHeight, width: self.frame.width, height: self.frame.height - self.headHeight)
    }

    deinit {
        print("deinit KMSheetView")
    }
}

extension KMSheetView:UITableViewDataSource {
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SheetCell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "SheetCell")
            cell?.selectionStyle = .none
            cell?.contentView.frame = CGRect.init(x: 0, y: 0, width: tableView.bounds.size.width, height: 50.0)
        }
        
        cell?.contentView.removeAllSubviews()
        UILabel().showIn((cell?.contentView)!, text: dataArray[indexPath.row])
        
        return cell!
    }
    
}

extension KMSheetView:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss()
        self.finishBlock(self.dataArray[indexPath.row] ,Int(indexPath.row))
    }
}

extension UILabel {

    func showIn(_ view:UIView, text:String) {
        self.font = UIFont.systemFont(ofSize: 14.0)
        self.textColor = UIColorFromRGBA(0x999999)
        self.text = text
        self.textAlignment = .center
        
        let width:CGFloat = 100,height:CGFloat = 14
        self.frame = CGRect(x:0,y:0,width:width,height:height)
        self.center = view.center
        
        view.addSubview(self)
    }
}

extension KMSheetView:KMMaskViewProtocol {
    
    func showInMask() {
        UIApplication.shared.delegate?.window??.addSubview(self.kmMaskView)
        UIApplication.shared.delegate?.window??.addSubview(self)
        
        self.kmMaskView.contentView = self
        
        UIView.animate(withDuration: kmMaskView.setting.duration) {
            self.kmMaskView.alpha = CGFloat(self.kmMaskView.setting.alpha)
            self.frame = CGRect.init(x: 0, y: SCREENHEIGHT - self.viewheight, width: SCREENWIDTH, height: self.viewheight)
        }
    }
    
    // Mark: 自定义参数
    func showInMask(setting: KMMaskSettingStruct) {
        
        
    }
    
    func dismiss() {
        UIView.animate(withDuration: kmMaskView.setting.duration, animations: {
            self.kmMaskView.alpha = 0.0
            self.frame = CGRect.init(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: self.viewheight)
        }, completion: { (finished) in
            self.kmMaskView.removeFromSuperview()
            self.removeFromSuperview()
        })
    }
}
