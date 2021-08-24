//
//  BCollectionViewAlignedLayout.swift
//  BNOA
//
//  Created by Cary on 2019/11/11.
//  Copyright © 2019 BNIC. All rights reserved.
//

import UIKit

protocol Alignment {}

public enum HorizontalAlignment: Alignment {
    case left
    case justified
    case right
}

public enum VerticalAlignment: Alignment {
    case top
    case center
    case botton
}

private struct AlignmentAxis<A: Alignment> {
    let alignment: A
    let position: CGFloat
}

public class BCollectionViewAlignedLayout: UICollectionViewFlowLayout {
    
    public var horizontalAlignment: HorizontalAlignment = .justified
    public var verticalAlignment: VerticalAlignment = .center
    
    fileprivate var alignmentAxis: AlignmentAxis<HorizontalAlignment>? {
        switch horizontalAlignment {
        case .left:
            return AlignmentAxis.init(alignment: HorizontalAlignment.left, position: sectionInset.left)
        case .right:
            guard let collectionViewWidth = collectionView?.frame.size.width else { return nil }
            return AlignmentAxis.init(alignment: HorizontalAlignment.right, position: collectionViewWidth - sectionInset.right)
        default:
            return nil
        }
    }
    
    private var contentWidth: CGFloat? {
        guard let collectionViewWidth = collectionView?.frame.size.width else { return nil }
        return collectionViewWidth - sectionInset.left - sectionInset.right
    }
    
    public init(horizontalAlignment: HorizontalAlignment = .justified, verticalAlignment: VerticalAlignment = .center) {
        super.init()
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else { return nil }
//
//        if horizontalAlignment != .justified {
//            layoutAttributes.ali
//        }
//    }
}

fileprivate extension UICollectionViewLayoutAttributes {
    
    private var currentSection: Int {
        return indexPath.section
    }
    
    private var currentItem: Int {
        return indexPath.item
    }
    
    private var precedingIndexPath: IndexPath {
        return IndexPath.init(item: currentItem + 1, section: currentItem)
    }
    
    
}
