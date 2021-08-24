//
//  LocationRecordCollectionView.swift
//  YiYangCloud
//
//  Created by gary on 2017/5/17.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import HandyJSON
import ESPullToRefresh

let LocationRecordCollectionView_Height:CGFloat = 240.0

class LocationRecordCollectionView: UIView {
    
    var isUp = false
    
    @IBOutlet weak var arrowBtn: UIButton!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    fileprivate let collectionCellReuseID = "LocationRecordCollectionViewCell"
    
    var tableView_1 =  UITableView()
    var tableView_2 =  UITableView()
    fileprivate let cellReuseIdentifier_1 = "LocationRecordTableViewCell_1"
    fileprivate let cellReuseIdentifier_2 = "LocationRecordTableViewCell_2"
    
    var cellClickBlock:((LocationRecord?) -> Void) = {model in }
    
    var originFrame:CGRect = CGRect.init(x:0,y:SCREENHEIGHT - NavHeight - 40,width:SCREENWIDTH,height:LocationRecordCollectionView_Height)
    var upFrame:CGRect = CGRect.init(x:0,y:SCREENHEIGHT - NavHeight - LocationRecordCollectionView_Height,width:SCREENWIDTH,height:LocationRecordCollectionView_Height)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lineView.centerX = (self.width - 60)/4
        
        func setupCollectionView() {
            self.flowLayout.itemSize = CGSize.init(width: SCREENWIDTH, height: LocationRecordCollectionView_Height - 40)
            
            self.collectionView.isPagingEnabled = true
            self.collectionView.bounces = false
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
            self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collectionCellReuseID)
        }
        
        func setupTableView() {
            self.tableView_1.tag = 10201
            self.tableView_2.tag = 10202
            self.tableView_1.api = APIs.API_Family_Type.LBSRecordNormal.getAPI() + "3315" + "/10/"
            self.tableView_2.api = APIs.API_Family_Type.LBSRecordEvent.getAPI() + "3315" + "/10/"
            self.tableView_1.cellID = cellReuseIdentifier_1
            self.tableView_2.cellID = cellReuseIdentifier_2
            self.tableView_1.commonInit(self, cellReuseID: cellReuseIdentifier_1)
            self.tableView_2.commonInit(self, cellReuseID: cellReuseIdentifier_2)
            self.tableView_1.es_startPullToRefresh()
        }
        
        func setupArrowButton() {
            arrowBtn.addTarget(self, action: #selector(arrowButtonDragMoving(control:withEvent:)), for: .touchDragInside)
            arrowBtn.addTarget(self, action: #selector(arrowButtonDragEnd(control:withEvent:)), for: .touchUpOutside)
        }
        
        setupCollectionView()
        setupTableView()
        setupArrowButton()
    }
    
    //Mark: 列表切换
    @IBAction func collectionButton_1_Click(_ sender: Any) {
        self.collectionView.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func collectionButton_2_Click(_ sender: Any) {
        self.collectionView.scrollToItem(at: IndexPath.init(item: 1, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    //Mark: 手势事件的控制
    func arrowButtonDragMoving(control:UIControl , withEvent event:UIEvent) {
//        var point:CGPoint = (event.allTouches!.first?.location(in: self))!
    }
   
    func arrowButtonDragEnd(control:UIControl , withEvent event:UIEvent) {
        
    }
    
    @IBAction func arrowButtonClick(_ sender: Any) {
        let rect = isUp ? originFrame : upFrame
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveLinear, animations: {
            self.frame = rect
            switchArrow()
        }) { (finished) in

        }
        
        // 旋转按钮
        func switchArrow() {
            let transform = CGAffineTransform(rotationAngle: CGFloat(isUp ? 0.0 : Double.pi));
            arrowBtn.imageView?.transform = transform
            isUp = !isUp
        }
    }
}

extension LocationRecordCollectionView{
    fileprivate func Animation (_ tag:Int){
        let centerX = tag == 0 ? (self.width - 60)/4 : self.width - (self.width - 60)/4
        
        UIView.animate(withDuration: 0.3, animations: {
            self.lineView.centerX = centerX
        })
    }
    
    // 控制器获取需要显示的默认数据
    public func getFirstLocationRecord() -> LocationRecord? {
        guard (tableView_1.dataArray?.count)! > 0 else {
            return nil
        }
        
        return tableView_1.dataArray?[0] as? LocationRecord
    }
    
    func loadData(_ tableView:UITableView) {
        
        let interactor = BaseInteractor(tableView.api! + "\(tableView.pageIndex)")
        interactor.loadData(success: { (json) in
            
            tableView.loadDataFinish(json as? String, viewBlock: {
                tableView.loadViewFinish(true)
                tableView.reloadData()
            }, modelType: LocationRecord())
            
        }) { (message) in
//            print(message ?? "")
            tableView.loadViewFinish(false)
        }
    }
}

extension LocationRecordCollectionView: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellReuseID, for: indexPath)
        
        if indexPath.item == 0 {
            cell.contentView.addSubview(self.tableView_1)
        }else {
            cell.contentView.addSubview(self.tableView_2)
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

extension LocationRecordCollectionView: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableView.dataArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: tableView.cellID, for:indexPath)
        cell.selectionStyle = .none
        
        let model: LocationRecord = tableView.dataArray?[indexPath.row] as! LocationRecord
        cell.imageView?.image = UIImage.init(named: model.getLocationTypeImage())
        cell.textLabel?.text = model.getData()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.cellClickBlock(tableView.dataArray?[indexPath.row] as? LocationRecord)
    }
}

private extension UITableView {
    
    func commonInit(_ delegateAndSource:LocationRecordCollectionView , cellReuseID:String) {
        let frame = CGRect.init(x: 0, y: 0, width: delegateAndSource.flowLayout.itemSize.width, height: delegateAndSource.flowLayout.itemSize.height)
        
        self.dataArray = []
        self.dataSource = delegateAndSource
        self.delegate = delegateAndSource
        self.rowHeight = 40.0
        self.showsVerticalScrollIndicator = false
        self.frame = frame
        self.cellID = cellReuseID
        self.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseID)
        self.contentOffset = CGPoint.init(x: 0, y: -90)
        self.backgroundColor = UIColorFromRGBA(0xf4f3f8)
        self.es_addPullToRefresh {
            [weak self , weak delegateAndSource] in
            /// 在这里做刷新相关事件
            self?.pageIndex = 1
            self?.loadingState = .refreshing
            delegateAndSource?.loadData(self!)
        }
        
        self.es_addInfiniteScrolling {
            [weak self , weak delegateAndSource] in
            /// 在这里做加载更多相关事件
            self?.addOnePage()
            delegateAndSource?.loadData(self!)
        }
        
    }

    
}

