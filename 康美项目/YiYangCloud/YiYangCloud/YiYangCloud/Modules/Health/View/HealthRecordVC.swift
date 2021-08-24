//
//  HealthRecordVC.swift
//  YiYangCloud
//
//  Created by gary on 2017/4/13.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import SVProgressHUD

class HealthRecordVC: UITableViewController {
    
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    
    var calendar = Calendar(identifier: .gregorian)
    
    var shadowView:UIView?
    
    
    lazy var format:DateFormatter = {
        let format = DateFormatter.init()
        format.dateFormat = "yyyy-MM-dd"
        return format
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navBarBgAlpha = "1.0"
        
        leftButton.frame = CGRect(x:0,y:0,width:55,height:24)
        self.dateBtn.setTitle(self.format.string(from: NSDate.init() as Date), for: .normal)
        
        let leftSwipe = UISwipeGestureRecognizer.init(target: self, action: #selector(self.handleSwipes(sender:)))
        leftSwipe.direction = .left
        let rightSwipe = UISwipeGestureRecognizer.init(target: self, action: #selector(self.handleSwipes(sender:)))
        rightSwipe.direction = .right
        self.tableView.addGestureRecognizer(leftSwipe)
        self.tableView.addGestureRecognizer(rightSwipe)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //1.获取最新血压血压体温心率值
        requestNewestData(date: (self.dateBtn.titleLabel?.text)!)
    }
    
    @IBOutlet weak var BPLab: UILabel!
    @IBOutlet weak var BSLab: UILabel!
    @IBOutlet weak var TWLab: UILabel!
    @IBOutlet weak var HRLab: UILabel!
    //Mark: button Action ---- navigation barButton
    @IBAction func navigateLeftButtonClick(_ sender: UIButton) {

        let action1 = PopoverAction.init(image: UIImage.init(named: "icon2"), title: "爸爸") { (action) in
            sender.setTitle(action?.title, for: .normal)
        }
        let action2 = PopoverAction.init(image: UIImage.init(named: "icon2"), title: "妈妈") { (action) in
            sender.setTitle(action?.title, for: .normal)
        }
        let action3 = PopoverAction.init(image: UIImage.init(named: "icon2"), title: "爷爷") { (action) in
            sender.setTitle(action?.title, for: .normal)
        }
        let action4 = PopoverAction.init(image: UIImage.init(named: "icon2"), title: "奶奶") { (action) in
            sender.setTitle(action?.title, for: .normal)
        }
        let action5 = PopoverAction.init(image: UIImage.init(named: "icon2"), title: "外公") { (action) in
            sender.setTitle(action?.title, for: .normal)
        }
        let action6 = PopoverAction.init(image: UIImage.init(named: "icon2"), title: "外婆") { (action) in
            sender.setTitle(action?.title, for: .normal)
        }
        let popoverView = PopoverView.init()
        popoverView.style = .default
        popoverView.hideAfterTouchOutside = true // 点击外部时不允许隐藏
        popoverView.show(to: CGPoint.init(x: sender.centerX, y: 64), with: [action1!, action2!, action3!, action4!, action5!, action6!])

    }
    
    @IBAction func navigateRightButtonClick(_ sender: Any) {
        
    }
    
    //Mark: button Action ---- head functions
    @IBAction func functionButtonClick(_ sender: UIButton) {
        // 100 - 104
        let classArray:Array = ["XYViewController","TWViewController","XTViewController","BSViewController","ZYViewController"]
        let className = NSClassFromString(ClassPrex + classArray[sender.tag-100]) as! UIViewController.Type
        
        let VC = className.init()
        if sender.tag == 104 {
            (VC as! ZYViewController).titleString = "中医体质分类与判定"
            (VC as! ZYViewController).urlString = "http://healthrecord.kmhealthcloud.cn:8091/tcq/?key=40626fb82c6b1c8087ec34be8434caf3"
        }
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    //Mark: button Action ---- canlender
    @IBAction func calenderButtonClick(_ sender: UIButton) {
        // 200 - 202
        switch sender.tag {
        case 200:
            var date = self.format.date(from: (self.dateBtn.titleLabel?.text)!)
            date = date?.addingTimeInterval(-86400)
            self.dateBtn.setTitle(self.format.string(from: date!), for: .normal)
        case 201:
            let xibView = Bundle.main.loadNibNamed("CalendarPopUp", owner: nil, options: nil)?[0] as! CalendarPopUp
            xibView.calendarDelegate = self
            xibView.selected = self.format.date(from: (self.dateBtn.titleLabel?.text)!)!
            PopupContainer.generatePopupWithView(xibView).show()
            
        case 202:
            var date = self.format.date(from: (self.dateBtn.titleLabel?.text)!)
            date = date?.addingTimeInterval(86400)
            self.dateBtn.setTitle(self.format.string(from: date!), for: .normal)
        default: break
            
        }
        requestNewestData(date: (self.dateBtn.titleLabel?.text)!)
    }
    
    //Mark: button Action ---- graphics
    @IBAction func graphicsButtonClick(_ sender: Any) {
        let webView = ZYViewController.init()
        webView.urlString = "/health_information?category=1&memberId=3315&memberIdNo=256656565656566&memberName=妈妈"
        webView.titleString  = "健康信息"
        self.navigationController?.pushViewController(webView, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer){
        if sender.direction == .left {
            var date = self.format.date(from: (self.dateBtn.titleLabel?.text)!)
            date = date?.addingTimeInterval(86400)
            self.dateBtn.setTitle(self.format.string(from: date!), for: .normal)
        }else if sender.direction == .right {
            
            var date = self.format.date(from: (self.dateBtn.titleLabel?.text)!)
            date = date?.addingTimeInterval(-86400)
            self.dateBtn.setTitle(self.format.string(from: date!), for: .normal)
            
        }
        
        requestNewestData(date: (self.dateBtn.titleLabel?.text)!)
    }
}

extension HealthRecordVC: CalendarPopUpDelegate {
    func dateChaged(date: Date) {
        self.dateBtn.setTitle(self.format.string(from: date), for: .normal)
        requestNewestData(date: (self.dateBtn.titleLabel?.text)!)
    }
}

// MARK: - 网络请求
extension HealthRecordVC{

    func requestNewestData(date:String){
        KMNetWork.fetchData(urlStrig: "http://\(ServerAddress)/app/member/findMemberNewsByDate/3315/\(date)", success: {
            [unowned self]
            (json) in
            let model = NewestDataModel.model(withJSON: json!)
            self.BPLab.text = model?.content?.bp != nil ? model?.content?.bp: "--"
            self.BSLab.text = model?.content?.bs != nil ? model?.content?.bs: "--"
            self.TWLab.text = model?.content?.temperature != nil ? model?.content?.temperature: "--"
            self.HRLab.text = model?.content?.hr != nil ? model?.content?.hr: "--"
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }

    }
}

func getInstanceFromClassName(_ type:String) -> UIViewController.Type {
    switch type {
    case "pe":
        return BSViewController.self
   
    default: return UIViewController.self
    }
}

