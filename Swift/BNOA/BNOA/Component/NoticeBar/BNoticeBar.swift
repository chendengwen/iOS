//
//  BNoticeBar.swift
//  BNOA
//
//  Created by Cary on 2019/11/11.
//  Copyright © 2019 BNIC. All rights reserved.
//

import UIKit

public enum BNoticeBarStyle {
    case onStatusBar
    case onNavigationBar
}

public enum BNoticeBarAnimationType {
    case top
    case botton
    case left
    case right
}

extension BNoticeBarAnimationType {
    
    fileprivate func noticeBarViewTransform(_ frame:CGRect, _ style:BNoticeBarStyle) -> CGAffineTransform {
        
        var transform = CGAffineTransform.identity
        
        switch (self) {
        case .top, .botton:
            transform = CGAffineTransform.init(translationX: 0, y: -frame.height)
        case .left:
            transform = CGAffineTransform.init(translationX: -frame.width, y: 0)
        case .right:
            transform = CGAffineTransform.init(translationX: frame.width, y: 0)
        }
        
        return transform
    }
}

fileprivate struct BNoticeBarProperties {
    init() {}
    
    var shadowOffsetY: CGFloat = 0
    var fontSizeScaleFactor: CGFloat = 0
    var textFont = UIFont()
    var viewFrame = CGRect.zero
    
    init(shadowOffsetY: CGFloat, fontSizeScaleFactor: CGFloat, textFont:UIFont, viewFrame: CGRect) {
        self.shadowOffsetY = shadowOffsetY
        self.fontSizeScaleFactor = fontSizeScaleFactor
        self.textFont = textFont
        self.viewFrame = viewFrame
    }
}

public struct BNoticeBarConfig {
    public init() { }
    
    public var title: String?
    public var image: UIImage? = nil
    public var margin: CGFloat = 10.0
    public var textColor: UIColor = UIColor.black
    public var backgroundColor = UIColor.white
    public var animationType = BNoticeBarAnimationType.top
    public var barStyle = BNoticeBarStyle.onNavigationBar
    
    public init(title: String? = nil,
                image: UIImage? = nil,
                textColor: UIColor = UIColor.white,
                backgroundColor: UIColor = UIColor.orange,
                barStyle: BNoticeBarStyle = .onNavigationBar,
                animationType: BNoticeBarAnimationType = .top) {
        self.title = title
        self.image = image
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.barStyle = barStyle
        self.animationType = animationType
    }
}

extension BNoticeBarStyle {
    
    fileprivate func noticeBarProperties() -> BNoticeBarProperties {
        let screenWidth = UIScreen.main.bounds.width
        
        var properties: BNoticeBarProperties
        switch self {
        case .onNavigationBar:
            properties = BNoticeBarProperties(shadowOffsetY: 3,
                                              fontSizeScaleFactor: 0.55,
                                              textFont: UIFont.systemFont(ofSize: 18),
                                              viewFrame: CGRect(origin: CGPoint.zero,
                                                                size: CGSize(width: screenWidth,
                                                                             height: 44.0 + UIApplication.shared.statusBarFrame.height)))
        case .onStatusBar:
            properties = BNoticeBarProperties(shadowOffsetY: 2,
                                              fontSizeScaleFactor: 0.75,
                                              textFont: UIFont.systemFont(ofSize: 13),
                                              viewFrame: CGRect(origin: CGPoint.zero,
                                                                size: CGSize(width: screenWidth,
                                                                             height: UIApplication.shared.statusBarFrame.height)))
        }
        
        return properties
        
    }
    
    fileprivate func noticeBarOriginY(superViewHeight: CGFloat, _ height: CGFloat) -> CGFloat {
        var originY: CGFloat = 0
        switch self {
        case .onNavigationBar:
            originY = UIApplication.shared.statusBarFrame.height + (superViewHeight - UIApplication.shared.statusBarFrame.height - height) * 0.5
        case .onStatusBar:
            originY = (superViewHeight - height) * 0.5
        }
        return originY
    }
    
    fileprivate var beginWindowLevel: UIWindow.Level {
        switch self {
        case .onStatusBar:
            return .statusBar + 1
        default:
            return .normal
        }
    }
    
    fileprivate var endWindoeLevel: UIWindow.Level {
        return .normal
    }
}

open class BNoticeBar: UIView {

    private var config = BNoticeBarConfig()
    
    open var titleLabel: UILabel? {
        return _titleLabel
    }
    
    open var imageView: UIImageView? {
        return _imageView
    }
    
    private var _titleLabel: UILabel?
    private var _imageView: UIImageView?

    public func show(duration: TimeInterval, completed: ((_ finished:Bool) -> Void)? = nil) {
        show(duration: duration, willShow: { [weak self] in
            guard let strongSelf = self else { return }
            let currentWindowLevel = strongSelf.config.barStyle.beginWindowLevel
            UIApplication.shared.keyWindow?.windowLevel = currentWindowLevel
        }) { [weak self] (finished) in
            guard let strongSelf = self else { return }
            completed?(finished)
            
            if finished {
                let currentWindowLevel = strongSelf.config.barStyle.endWindoeLevel
                UIApplication.shared.keyWindow?.windowLevel = currentWindowLevel
            }
        }
    }
    
    public init(config: BNoticeBarConfig) {
        super.init(frame: config.barStyle.noticeBarProperties().viewFrame)
        self.backgroundColor = config.backgroundColor
        
        self.config = config
        
        self.layer.shadowOffset = CGSize.init(width: 0, height: config.barStyle.noticeBarProperties().shadowOffsetY)
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.44
        
        configSubviews()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configSubviews() {
        _titleLabel = UILabel()
        _titleLabel?.text = config.title
        _titleLabel?.textColor = config.textColor
        _titleLabel?.minimumScaleFactor = config.barStyle.noticeBarProperties().fontSizeScaleFactor
        _titleLabel?.adjustsFontSizeToFitWidth = true
        _titleLabel?.font = config.barStyle.noticeBarProperties().textFont
        addSubview(_titleLabel!)
        
        var titleLabelOriginX: CGFloat = 0
        var titleLabelOriginY: CGFloat = 0
        var titleLabelWidth: CGFloat = 0
        var titleLabelHeight: CGFloat = 0
        
        if let image = config.image, config.barStyle != .onStatusBar {
            _imageView = UIImageView.init(image: image)
            _imageView?.contentMode = .scaleAspectFill
            addSubview(_imageView!)
            
            let imageViewWidth: CGFloat = 25
            let imageViewOriginX = config.margin + 10
            let imageViewOriginY = config.barStyle.noticeBarOriginY(superViewHeight: frame.height, imageViewWidth)
            _imageView?.frame = CGRect.init(origin: CGPoint.init(x: imageViewOriginX, y: imageViewOriginY), size: CGSize.init(width: imageViewWidth, height: imageViewWidth))
            
            titleLabelOriginX = _imageView!.frame.maxX + config.margin
            titleLabelOriginY = _imageView!.frame.origin.y
            titleLabelHeight = _imageView!.frame.size.height
            titleLabelWidth = UIScreen.main.bounds.width - titleLabelOriginX - config.margin
            _titleLabel?.textAlignment = .left
        } else {
            _titleLabel?.textAlignment = .center
            
            titleLabelHeight = 25
            titleLabelWidth = UIScreen.main.bounds.width - 2*config.margin
            titleLabelOriginX = config.margin
            titleLabelOriginY = config.barStyle.noticeBarOriginY(superViewHeight: frame.height, titleLabelHeight)
        }
        
        _titleLabel?.frame = CGRect(x: titleLabelOriginX, y: titleLabelOriginY, width: titleLabelWidth, height: titleLabelHeight)
    }
    
    private func show(duration: TimeInterval, willShow: () -> Void, completed: ((_ finished: Bool) -> Void)?) {
        if let subviews = UIApplication.shared.keyWindow?.subviews {
            for view in subviews {
                if view.isKind(of: BNoticeBar.self) {
                    view.removeFromSuperview()
                }
            }
        }
        
        willShow()
        
        UIApplication.shared.keyWindow?.addSubview(self)
        
        self.transform = config.animationType.noticeBarViewTransform(frame, self.config.barStyle)
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }) { (_) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: {
                UIView.animate(withDuration: 0.4, animations: {
                    self.transform = self.config.animationType.noticeBarViewTransform(self.frame, self.config.barStyle)
                }, completion: { (_) in
                    completed?(true)
                    self.removeFromSuperview()
                })
            })
        }
    }
}
