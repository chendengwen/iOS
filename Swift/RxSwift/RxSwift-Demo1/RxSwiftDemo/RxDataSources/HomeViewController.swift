//
//  LXFViewController.swift
//  RxSwiftDemo
//
//  Created by 林洵锋 on 2017/9/7.
//  Copyright © 2017年 LXF. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources




class HomeViewController: UIViewController {
    
    @IBOutlet weak var mTableView: UITableView!
    
    let reuserId = "cell"
    let disposeB = DisposeBag()
    let datas = githubData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "RxSwift"
        self.mTableView.register(RxTableCell.self, forCellReuseIdentifier: reuserId)
        
        /*
         只适用于只有一个 section 的情况，多个 section 使用 RxDataSources 非常方便
         
         let items = Observable.just([
             DataModel(name: "hello__1_ponna", gitHubID: "001"),
             DataModel(name: "hello__2_112jadjawd", gitHubID: "002"),
             DataModel(name: "hello__3_qwdqwdqwdqw", gitHubID: "003"),
             DataModel(name: "hello__4_qwdqsdvdfvdf", gitHubID: "004"),
         ])
         
        //分解的写法
//        typealias O = Observable<[DataModel]>
//        typealias CC = (Int, DataModel, RxTableCell) -> Void
//        let curriedArgument = { (rowIndex: Int, element: DataModel, cell: RxTableCell) in
//            cell.textLabel?.text = element.name
//            cell.detailTextLabel?.text = element.gitHubID
//        }
//        let binder: (O) -> (@escaping CC) -> Disposable =
//            mTableView.rx.items(cellIdentifier: reuserId, cellType: RxTableCell.self)
//        items.bind(to: binder, curriedArgument: curriedArgument).disposed(by: disposeB)
        
        //链式写法
        items.bind(to: mTableView.rx.items(cellIdentifier: reuserId, cellType: RxTableCell.self)) { (rowIndex: Int, element: DataModel, cell: RxTableCell) in
            cell.textLabel?.text = element.name
            cell.detailTextLabel?.text = element.gitHubID
        }.disposed(by: disposeB)
         */
        
        //RxDataSources写法
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, DataModel>>(
                            configureCell: { [weak self](ds, tb, index, model) -> RxTableCell in
                                let cell = tb.dequeueReusableCell(withIdentifier: (self?.reuserId)!, for: index) as? RxTableCell

                               // cell?.detailTextLabel?.backgroundColor = UIColor.orange
                                cell?.imageView?.image = model.image
                                cell?.textLabel?.text = model.name
                                cell?.detailTextLabel?.text = model.gitHubID
                                return cell!
                            },
                            titleForHeaderInSection:{ds, index in
                                return ds.sectionModels[index].model
                            }
                        )
        githubData
        .asDriver(onErrorJustReturn: [])
        .drive(mTableView.rx.items(dataSource: dataSource))
        .disposed(by:disposeB)
        
        mTableView.rx.itemSelected
        .subscribe(onNext:{ [weak self] indexPath in
            if indexPath.section == 0 {
                self?.navigationController?.pushViewController(LoginViewController(), animated: true)
            } else if indexPath.section == 1 {
                self?.present(NetworkViewController(), animated: true, completion: nil)
            }
            
        }).disposed(by:disposeB)
        //itemSelected取代了下面的写法
//        myTableView.delegate = self
//        myTableView.rx.setDelegate(self).disposed(by: disposeB)
    }
    
    
}


