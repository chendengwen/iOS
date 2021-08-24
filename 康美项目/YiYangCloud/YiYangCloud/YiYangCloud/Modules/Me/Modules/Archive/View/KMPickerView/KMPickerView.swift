//
//  KMPickerView.swift
//
//
//  Created by Gary on 15/10/23.
//  Copyright © 2017年 Gary. All rights reserved.
//

import UIKit

class KMPickerView: UIPickerView,UIPickerViewDelegate, UIPickerViewDataSource {

    let viewheight: CGFloat = 200
    var kmMaskView:KMMaskView = KMMaskView()
    var finishBlock:(String) -> () = { (text:String) in }
    
    var dataArray: Array<PickerBaseModel> = []
    var pickType:KMPicker_Type = .city
    
    var indexTuple = (index_0:0,index_1:0,index_2:0)
    
    var cancelBtn:UIButton?
    var finishBtn:UIButton?
    
    func initType(_ type:KMPicker_Type, defaultValue : [String]){       // [String] = ["广东","深圳","福田"]
        self.frame = CGRect.init(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: viewheight)
        
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.white
        pickType = type
        dataArray = KMPickerModelFactory.getDataArray(type) as! Array<PickerBaseModel>
        
        if defaultValue.count > 0 {
            
            let defaultModelArr = dataArray.enumerated().flatMap({ (offset:Int,element:PickerBaseModel) -> PickerBaseModel? in
                let text = element.text
                if (text.contains(defaultValue[0]) || defaultValue[0].contains(text)) {
                    self.indexTuple.index_0 = offset
                    return element
                }
                return nil
                })
            
            let defaultModel:PickerBaseModel = defaultModelArr.last!
            
            var cityAreaModelArr:Array<PickerBaseModel>?
            if defaultValue.count > 1 {
                cityAreaModelArr = defaultModel.subArr.enumerated().flatMap({ (offset: Int, element: PickerBaseModel) -> PickerBaseModel? in
                    if (element.text.contains(defaultValue[1]) || defaultValue[1].contains(element.text)) {
                        self.indexTuple.index_1 = offset
                        return element
                    }
                    return nil
                })
            }
            
            if defaultValue.count > 2 && cityAreaModelArr != nil {
                _ = cityAreaModelArr?.last?.subArr.enumerated().map({ (offset: Int, element: PickerBaseModel) in
                    if (element.text.contains(defaultValue[2]) || defaultValue[2].contains(element.text)) {
                        self.indexTuple.index_2 = offset
                    }
                })
            }
            
            layoutViews()
            
            for i in 0 ..< self.numberOfComponents {
                let arr = [indexTuple.0,indexTuple.1,indexTuple.2]
                self.selectRow(arr[i], inComponent: i, animated: false)
            }        
        }
    }
    
    fileprivate func layoutViews() {
        
        let headHeight:CGFloat = 40.0   // 顶部按钮区高度
        
        // 顶部区域
        let headBG = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: headHeight))
        headBG.backgroundColor = UIColorFromRGBA(0xf8f8f8)
        self.addSubview(headBG)
        
        let titleLabWidth:CGFloat = 100.0 , titleLabHeight:CGFloat = 16.0
        let titleLab = UILabel()
        titleLab.frame = CGRect.init(x:(self.frame.width - titleLabWidth)/2, y:(headBG.frame.height - titleLabHeight)/2, width: titleLabWidth, height: titleLabHeight)
        titleLab.font = UIFont.systemFont(ofSize: 14.0)
        titleLab.text = "选择"
        titleLab.textColor = UIColorFromRGBA(0x666666)
        
        let line = UIView.init(frame: CGRect.init(x: 0, y: headBG.frame.height - 0.5, width: headBG.frame.width, height: 0.5))
        line.backgroundColor = UIColorFromRGBA(0xE3E3E3)
        headBG.addSubview(line)
        
        let btnWidth:CGFloat = 40.0 , btnHeight:CGFloat = 30.0
        cancelBtn = UIButton.init(frame: CGRect.init(x: 15, y: (headBG.frame.height - btnHeight)/2, width: btnWidth, height: btnHeight))
        finishBtn = UIButton.init(frame: CGRect.init(x: headBG.frame.width - 15 - btnWidth, y: (headBG.frame.height - btnHeight)/2, width: btnWidth, height: btnHeight))
        
        cancelBtn?.setTitle("取消", for: .normal)
        cancelBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        cancelBtn?.setTitleColor(UIColorFromRGBA(0x007AFF), for: .normal)
        cancelBtn?.addTarget(self, action: #selector(KMPickerView.cancel), for: .touchUpInside)
        
        finishBtn?.setTitle("完成", for: .normal)
        finishBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        finishBtn?.setTitleColor(UIColorFromRGBA(0x007AFF), for: .normal)
        finishBtn?.addTarget(self, action: #selector(KMPickerView.finish), for: .touchUpInside)
        
        headBG.addSubview(cancelBtn!)
        headBG.addSubview(finishBtn!)
        
    }
    
    func getPickerViewResult() -> String{
        let pModel:PickerBaseModel = dataArray[indexTuple.index_0] 
        let (text_0,text_1,text_2) = (pModel.text,pModel.subArr[indexTuple.index_1].text,pModel.subArr[indexTuple.index_1].subArr[indexTuple.index_2].text)

        var address = text_0
        for i in 1 ..< self.numberOfComponents {
            address = address + ((Int(text_0) != nil) ? "-" : " ") + [text_0,text_1,text_2][i]
        }
        return address
    }
    
    
    func cancel(_ sender: Any) {
        dismiss()
    }
    
    func finish(_ sender: Any) {
        self.finishBlock(getPickerViewResult())
        dismiss()
    }
    
    //Mark: 解决pickerView遮挡button手势的bug
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        let finishBtnPoint = finishBtn?.convert(point, from: self)
        let cancelBtnPoint = finishBtn?.convert(point, from: self)
        
        if (finishBtn?.point(inside: finishBtnPoint!, with: event))! {
            return finishBtn
        }
        
        if (cancelBtn?.point(inside: cancelBtnPoint!, with: event))! {
            return cancelBtn
        }
        
        return view
    }
    
    
    @available(iOS 2.0, *)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickType.numberOfComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var number : Int = 0
        
        switch (component) {
        case 0:
            number = dataArray.count
            break
        case 1:
            number = dataArray[indexTuple.index_0].subArr.count
            break
        case 2:
            number = dataArray[indexTuple.index_0].subArr[indexTuple.index_1].subArr.count
            break
        default :
            break
        }
        return number;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var text : String = "请选择"
        let pModel : PickerBaseModel = dataArray[indexTuple.index_0]
        let cModel : PickerBaseModel = pModel.subArr[indexTuple.index_1]
        
        switch (component) {
        case 0:
            text = dataArray[row].text
            break
        case 1:
            text = pModel.subArr[row].text
            break
        case 2:
            text = cModel.subArr[row].text
            break
        default :
            break
        }
        return text
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (0 == component) {
            indexTuple.index_0 = row
            indexTuple.index_1 = 0
            indexTuple.index_2 = 0
            
            for i in component+1 ..< pickerView.numberOfComponents {
                pickerView.reloadComponent(i)
                pickerView.selectRow(0, inComponent: i, animated: true)
            }
            
        } else if (1 == component) {
            
            indexTuple.index_1 = row
            
            for i in component+1 ..< pickerView.numberOfComponents {
                pickerView.reloadComponent(i)
                pickerView.selectRow(0, inComponent: i, animated: true)
            }
            
        } else if (2 == component) {
            indexTuple.index_2 = row
        }
    }

}


extension KMPickerView:KMMaskViewProtocol {
    
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
    func showInMask(setting: KMMaskSettingStruct) {}
    
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
