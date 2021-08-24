//
//  ViewController.swift
//  CCQRCode
//
//  Created by cyd on 2018/7/9.
//  Copyright © 2018 cyd. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "单击view进入相册"
        self.view.backgroundColor = UIColor.white
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let imgPicker = UIImagePickerController()
        imgPicker.sourceType = .savedPhotosAlbum
        imgPicker.delegate = self
        self.present(imgPicker, animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // 取出图片
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        guard image!.isKind(of: UIImage.self) else {
            return
        }
        
        // 获取二维码信息
        let messages = self.findQRCode(image: image!)
        print(messages)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ViewController {
    
    func findFace(image : UIImage) -> CGRect? {
        //1 将UIImage转换成CIImage
        let ciImage:CIImage! = CIImage.init(image: image)
        //2.设置人脸识别精度
        let options:[String : Any] = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        //3.创建人脸探测器
        let detector:CIDetector = CIDetector.init(ofType: CIDetectorTypeFace, context: nil, options: options)!
        //4.获取人脸识别数据
        let features = detector.features(in: ciImage, options: nil)
        
        var maxFace:CGRect?
        var area:CGFloat = 0.0
        for faceFeature in features where faceFeature.isKind(of: CIFaceFeature.self) {
            if (faceFeature.bounds.size.width * faceFeature.bounds.size.width) > area {
                maxFace = faceFeature.bounds;
                area = faceFeature.bounds.size.width * faceFeature.bounds.size.width;
            }
        }
        
        return maxFace
    }
    
    func findQRCode(image : UIImage) -> [String] {
        // 1.生成CIImage
        let ciimage = CIImage(cgImage: image.cgImage!)
        // 2.识别精度
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        
        /**
         3.创建识别器，3个参数
         
         ofType：识别类型
         CIDetectorTypeFace      面部识别
         CIDetectorTypeText      文本识别
         CIDetectorTypeQRCode    条码识别
         CIDetectorTypeRectangle 矩形识别
         
         context：上下文，默认传nil
         
         options：识别精度
         CIDetectorAccuracyLow  低精度，识别速度快
         CIDetectorAccuracyHigh 高精度，识别速度慢
         */
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: options)
        
        /**
         4.获取识别结果，2个参数
         
         in：需要识别的图片
         
         options：需要识别的特征
         CIDetectorMinFeatureSize: 指定最小尺寸的检测器，小于这个尺寸的特征将不识别，CIDetectorTypeFace(0.01 ~ 0.50)，CIDetectorTypeText(0.00 ~ 1.00)，CIDetectorTypeRectangle(0.00 ~ 1.00)
         CIDetectorTracking: 是否开启面部追踪 TRUE 或 FALSE
         CIDetectorMaxFeatureCount: 设置返回矩形特征的最多个数 1 ~ 256 默认值为1
         CIDetectorNumberOfAngles: 设置角度的个数 1, 3, 5, 7, 9, 11
         CIDetectorImageOrientation: 识别方向
         CIDetectorEyeBlink: 眨眼特征
         CIDetectorSmile: 笑脸特征
         CIDetectorFocalLength: 每帧焦距
         CIDetectorAspectRatio: 矩形宽高比
         CIDetectorReturnSubFeatures: 文本检测器是否应该检测子特征，默认值是否
         */
        let features = detector?.features(in: ciimage, options: nil)
        
        var messageArr:[String] = []
        // 遍历出二维码(通过截屏的二维码很容易识别出，如果是拍照的二维码，很可能识别不出来)
        for item in features! where item.isKind(of: CIQRCodeFeature.self) {
            let message = (item as! CIQRCodeFeature).messageString ?? ""
            //print(message)
            messageArr.append(message)
        }
        
        return messageArr;
    }

}
