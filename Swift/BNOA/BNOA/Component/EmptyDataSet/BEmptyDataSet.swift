//
//  BEmptyDataSet.swift
//  BNOA
//
//  Created by Cary on 2019/11/11.
//  Copyright © 2019 BNIC. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

extension UIScrollView {
    
    private struct AssociatedKeys {
        static var bEmptyKey: Void?
    }
    
    var bEmpty: BEmptyView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.bEmptyKey) as? BEmptyView
        }
        set {
            self.emptyDataSetSource = newValue
            self.emptyDataSetDelegate = newValue
            objc_setAssociatedObject(self, &AssociatedKeys.bEmptyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

class BEmptyView: EmptyDataSetSource, EmptyDataSetDelegate {

    var image: UIImage?
    
    var allowShow: Bool = false
    var verticalOffset: CGFloat = 0
    
    private var tapClosure: (() -> Void)?
    
    init(image: UIImage? = UIImage.init(named: "nodata"), verticalOffset: CGFloat = 0, tapClosure: (() -> Void)?) {
        self.image = image
        self.verticalOffset = verticalOffset
        self.tapClosure = tapClosure
    }
    
    internal func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return image
    }
    
    internal func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return allowShow
    }
    
    internal func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        guard let tapClosure = tapClosure else { return }
        tapClosure()
    }
}
