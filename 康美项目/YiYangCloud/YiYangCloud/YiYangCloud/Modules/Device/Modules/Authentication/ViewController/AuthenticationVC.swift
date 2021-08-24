//
//  AuthenticationVC.swift
//  YiYangCloud
//
//  Created by 钟晓跃 on 2017/6/1.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

class AuthenticationVC: UIViewController {
    
    var scrollView = UIView.init()
    let rightBtn = UIButton.init()
    let leftBtn = UIButton.init()
    
    lazy var webView:WKWebView = {
        let webView = WKWebView.init(frame: CGRect.init(x: 0, y: 8, width: SCREENWIDTH, height: SCREENHEIGHT - 124))
        let url = URL(string:"http://10.2.20.238:7000/app/device/deviceManage/3315/admin/866545022045261/contactInfo")
        let request = URLRequest(url: url!)
        webView.load(request)
        return webView
    }()

    lazy var flowLayout:UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSize.init(width: CGFloat(SCREENWIDTH), height: SCREENHEIGHT - 108)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }()
    
    lazy var collectionView:UICollectionView = {
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionViewCell")
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    lazy var leftView:UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT - 108))
        view.backgroundColor = UIColor.white
        
        let borderView = UIView.init()
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.init(hex: 0xeeeeee).cgColor
        borderView.layer.cornerRadius = 2
        borderView.layer.masksToBounds = true
        view.addSubview(borderView)
        borderView.snp.makeConstraints({ (make) in
            make.left.equalTo(view).offset(15)
            make.top.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-15)
            make.height.equalTo(40)
        })
        
        let imgV = UIImageView.init(image: UIImage.init(named: "shouji"))
        borderView.addSubview(imgV)
        imgV.snp.makeConstraints({ (make) in
            make.centerY.equalTo(borderView)
            make.left.equalTo(borderView).offset(10)
        })
        
        let text = UITextField.init()
        text.borderStyle = .none
        text.keyboardType = .numberPad
        text.font = UIFont.systemFont(ofSize: 14)
        text.placeholder = "请输入手表SIM卡卡号"
        borderView.addSubview(text)
        text.snp.makeConstraints({ (make) in
            make.left.equalTo(imgV).offset(22)
            make.right.equalTo(borderView).offset(-8)
            make.centerY.equalTo(borderView)
        })
        
        let centerPhotoBtn = PhotoBtn.init()
        centerPhotoBtn.tag = 101
        centerPhotoBtn.addTarget(self, action: #selector(self.didClickPhotoBtn(sender:)), for: .touchUpInside)
        centerPhotoBtn.title?.text = "上传身份证反面"
        view.addSubview(centerPhotoBtn)
        centerPhotoBtn.snp.makeConstraints({ (make) in
            make.centerX.equalTo(view)
            make.height.equalTo(71)
            make.width.equalTo(103)
            make.top.equalTo(borderView.snp.bottom).offset(35)
        })
        
        let leftPhotoBtn = PhotoBtn.init()
        leftPhotoBtn.tag = 100
        leftPhotoBtn.addTarget(self, action: #selector(self.didClickPhotoBtn(sender:)), for: .touchUpInside)
        leftPhotoBtn.title?.text = "上传身份证正面"
        view.addSubview(leftPhotoBtn)
        leftPhotoBtn.snp.makeConstraints({ (make) in
            make.right.equalTo(centerPhotoBtn.snp.left).offset(-15)
            make.height.equalTo(71)
            make.width.equalTo(103)
            make.top.equalTo(centerPhotoBtn)
        })
        
        let rightPhotoBtn = PhotoBtn.init()
        rightPhotoBtn.tag = 102
        rightPhotoBtn.addTarget(self, action: #selector(self.didClickPhotoBtn(sender:)), for: .touchUpInside)
        rightPhotoBtn.title?.text = "自拍头像"
        rightPhotoBtn.imgV?.image = UIImage.init(named: "paizao")
        view.addSubview(rightPhotoBtn)
        rightPhotoBtn.snp.makeConstraints({ (make) in
            make.left.equalTo(centerPhotoBtn.snp.right).offset(15)
            make.height.equalTo(71)
            make.width.equalTo(103)
            make.top.equalTo(centerPhotoBtn)
        })
        
        let commitBtn = UIButton.init()
        commitBtn.setTitle("提交", for: .normal)
        commitBtn.backgroundColor = UIColor.init(hex: 0x507AF8)
        commitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        commitBtn.setTitleColor(UIColor.init(hex: 0xffffff), for: .normal)
        commitBtn.addTarget(self, action: #selector(self.didClickCommitBtn(sender:)), for: .touchUpInside)
        commitBtn.layer.cornerRadius = 20
        commitBtn.layer.masksToBounds = true
        view.addSubview(commitBtn)
        commitBtn.snp.makeConstraints({ (make) in
            make.top.equalTo(centerPhotoBtn.snp.bottom).offset(40)
            make.left.equalTo(view).offset(15)
            make.right.equalTo(view).offset(-15)
            make.height.equalTo(40)
        })
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configNavBar()
        
        self.configView()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - Action
extension AuthenticationVC {
    func didClickCommitBtn(sender:UIButton){
        
    }
    
    func didClickPhotoBtn(sender:UIButton){
        
    }
    
    func Animation (_ tag:Int){
        let centerX = tag == 0 ? self.leftBtn.centerX : self.rightBtn.centerX
        UIView.animate(withDuration: 0.5, animations: {
            self.scrollView.centerX = centerX
        })
    }
    
    func didChangeBtn(sender:UIButton){
         self.collectionView.scrollToItem(at: IndexPath.init(item: sender.tag, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension AuthenticationVC:UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath)
        
        if indexPath.item == 0 {
            cell.contentView.addSubview(self.leftView)
        }else {
            cell.contentView.addSubview(self.webView)
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isEqual(self.collectionView){
            let offsetx = scrollView.contentOffset.x
            let currentPage = Int (offsetx / SCREENWIDTH + 0.5)
            Animation(currentPage)
        }
    }
}

// MARK: - UI
extension AuthenticationVC{
    func configNavBar() {
        self.title = "SIM卡实名认证"
    }
    
    func configView() {
        self.view.backgroundColor = UIColor.init(hex: 0xF4F3F8)
        let topView = UIView.init()
        topView.backgroundColor = UIColor.white
        self.view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(44)
        }
        
        leftBtn.setTitle("官网激活", for: .normal)
        leftBtn.tag = 0
        leftBtn.addTarget(self, action: #selector(self.didChangeBtn(sender:)), for: .touchUpInside)
        leftBtn.setTitleColor(UIColor.init(hex: 0x666666), for: .normal)
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        topView.addSubview(leftBtn)
        leftBtn.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(topView)
            make.width.equalTo(topView).multipliedBy(0.5)
        }
        
        rightBtn.setTitle("空中入网业务", for: .normal)
        rightBtn.tag = 1
        rightBtn.addTarget(self, action: #selector(self.didChangeBtn(sender:)), for: .touchUpInside)
        rightBtn.setTitleColor(UIColor.init(hex: 0x666666), for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        topView.addSubview(rightBtn)
        rightBtn.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(topView)
            make.width.equalTo(topView).multipliedBy(0.5)
        }
        
        self.scrollView.backgroundColor = UIColor.init(hex: 0x507AF8)
        self.scrollView.frame = CGRect.init(x: 0, y: 42, width: SCREENWIDTH / 6.0 , height: 2)
        self.scrollView.centerX = SCREENWIDTH / 4.0
        topView.addSubview(self.scrollView)
        
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(20)
            make.left.right.bottom.equalTo(self.view)
        }
    }
}
