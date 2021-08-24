//
//  JTAppleCollectionReusableView.swift
//  Pods
//
//  Created by JayT on 2016-05-11.
//
//

/// The header view class of the calendar
open class JTAppleCollectionReusableView: UICollectionReusableView, JTAppleReusableViewProtocol {
    /// Header view to be customized
    var view: JTAppleHeaderView?
    
    func update() {
        view!.frame = frame
        view!.center = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    /// Returns an object initialized from data in a given unarchiver.
    /// self, initialized using the data in decoder.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
