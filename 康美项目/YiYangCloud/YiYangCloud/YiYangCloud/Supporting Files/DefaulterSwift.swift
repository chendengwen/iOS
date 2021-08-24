//
//  DefaulterSwift.swift
//  YiYangCloud
//
//  Created by gary on 2017/4/13.
//  Copyright © 2017年 gary. All rights reserved.
//

public func curryAB<A, B>(_ function: @escaping (A) -> B) -> (A) -> B {
    return { (a: A) -> B in function(a) }
}

//Mark: Size
let SCREENWIDTH = UIScreen.main.bounds.size.width
let SCREENHEIGHT = UIScreen.main.bounds.size.height

let NavHeight:CGFloat = 64.0
let IS_IPHONE_4_OR_LESS = SCREENHEIGHT < 568.0
let IS_IPHONE_5 = SCREENHEIGHT == 568.0
let IS_IPHONE_6 = SCREENHEIGHT == 667.0
let IS_IPHONE_6P = SCREENHEIGHT == 736.0

func Rect(_ x:CGFloat = 0.0, _ y:CGFloat = 0.0, width:CGFloat, height:CGFloat) -> CGRect {
    return CGRect.init(x:x,y:y,width:width,height:height)
}
/////////////////////////////////////////////


//Mark: Color
var RandomColor:UIColor = UIColor.init(colorLiteralRed: Float(drand48()), green: Float(drand48()), blue: Float(drand48()), alpha: 1.0)

func UIColorFromRGBA(_ value:Int) -> UIColor {
    let R:Float = Float((value & 0xFF0000) >> 16);
    let G:Float = Float((value & 0xFF00) >> 8);
    let B:Float = Float((value & 0xFF));
    return UIColor.init(colorLiteralRed: R/255.0, green: G/255.0, blue: B/255.0, alpha: 1.0)
}

func UIColorFromRGB_Z(_ r:CGFloat,_ g:CGFloat,_ b:CGFloat) -> UIColor {
    return UIColor(red:r/255.0, green:g/255.0, blue:b/255.0, alpha:1.00)
}

let BlueColor = UIColorFromRGBA(0x507AF8)
/////////////////////////////////////////////

let ProjectName = "YiYangCloud."
let ClassPrex   = "YiYangCloud."

public typealias Parameters = [String: Any]

let HKVersion = (UIDevice.current.systemVersion as NSString).doubleValue
let CustomHealthErrorDomain = "com.sdqt.healthError"

let KMDateFormatter:DateFormatter = {
    let format = DateFormatter.init()
    format.dateFormat = "YYYY-MM-dd HH:mm:ss"
    return format
}()


let UID = UserCacheManager.shared().userModel.uid

