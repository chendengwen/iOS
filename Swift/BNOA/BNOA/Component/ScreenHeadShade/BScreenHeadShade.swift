//
//  ScreenHeadShade.swift
//  BNOA
//
//  Created by Cary on 2019/11/11.
//  Copyright © 2019 BNIC. All rights reserved.
//

import UIKit

open class BScreenHeadShade {
    
    public static let instance = BScreenHeadShade()
    
    private class ScreenHeadShadeView: UIView {
        static let cornerRadius: CGFloat = 40
        static let cornerY: CGFloat = 35
        
        //Mark: 注意没有调用super.draw() 只绘制指定区间
        override func draw(_ rect: CGRect) {
            let width = frame.width > frame.height ? frame.height : frame.width
            
            let rectPath = UIBezierPath()
            rectPath.move(to: CGPoint.init(x: 0, y: 0))
            rectPath.addLine(to: CGPoint.init(x: width, y: 0))
            rectPath.addLine(to: CGPoint.init(x: width, y: ScreenHeadShadeView.cornerY))
            rectPath.addLine(to: CGPoint.init(x: 0, y: ScreenHeadShadeView.cornerY))
            rectPath.close()
            rectPath.fill()
            
            let leftCornerPath = UIBezierPath()
            leftCornerPath.move(to: CGPoint.init(x: 0, y: ScreenHeadShadeView.cornerY + ScreenHeadShadeView.cornerRadius))
            leftCornerPath.addLine(to: CGPoint.init(x: 0, y: ScreenHeadShadeView.cornerY))
            leftCornerPath.addLine(to: CGPoint.init(x: ScreenHeadShadeView.cornerRadius, y: ScreenHeadShadeView.cornerY))
            leftCornerPath.addQuadCurve(to: CGPoint.init(x: 0, y: ScreenHeadShadeView.cornerY + ScreenHeadShadeView.cornerRadius), controlPoint: CGPoint.init(x: 0, y: ScreenHeadShadeView.cornerY))
            leftCornerPath.close()
            leftCornerPath.fill()
            
            let rightCornerPath = UIBezierPath()
            rightCornerPath.move(to: CGPoint(x: width, y: ScreenHeadShadeView.cornerY + ScreenHeadShadeView.cornerRadius))
            rightCornerPath.addLine(to: CGPoint(x: width, y: ScreenHeadShadeView.cornerY))
            rightCornerPath.addLine(to: CGPoint(x: width - ScreenHeadShadeView.cornerRadius, y: ScreenHeadShadeView.cornerY))
            rightCornerPath.addQuadCurve(to:  CGPoint(x: width, y: 35 + ScreenHeadShadeView.cornerRadius), controlPoint: CGPoint(x: width, y: ScreenHeadShadeView.cornerY))
            rightCornerPath.close()
            rightCornerPath.fill()
        }
    }
    
    private var shadeWindow: UIWindow = {
        let width = UIApplication.shared.keyWindow?.frame.width ?? 0
        let height = UIApplication.shared.keyWindow?.frame.height ?? 0
        
        let sWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        sWindow.windowLevel = UIWindow.Level.statusBar - 1
        
        let shadeView = ScreenHeadShadeView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: height))
        shadeView.backgroundColor = UIColor.clear
        shadeView.clipsToBounds = true
        sWindow.addSubview(shadeView)
        
        return sWindow
    }()
    
    public func spread() {
        guard isIphoneX else { return }
        guard let window = UIApplication.shared.keyWindow else { return }
        if #available(iOS 11.0, *) {
            if window.safeAreaInsets.top > 0.0 {
                DispatchQueue.main.async { [weak self] in
                    self?.shadeWindow.makeKeyAndVisible()
                    DispatchQueue.main.async {
                        window.makeKey()
                    }
                }
            }
            
        }
    }
}
