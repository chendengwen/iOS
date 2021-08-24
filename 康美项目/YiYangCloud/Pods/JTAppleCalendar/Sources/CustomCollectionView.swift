//
//  CustomCollectionViewswift.swift
//  JTAppleCalendar
//
//  Created by JayT on 2017-02-15.
//
//

class CustomCollectionView: UICollectionView {
    var completionHandler: (() -> Void)? = nil
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let completionHandler = completionHandler else { return }
        self.completionHandler = nil
        completionHandler()
    }
}

