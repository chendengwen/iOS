//
//  ViewController.m
//  Image2Gray
//
//  Created by mac on 2019/6/17.
//  Copyright © 2019 Gary. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIImage *_image;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UISlider *slideBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _image = [UIImage imageNamed:@"idcard.png"];
}

- (IBAction)slideBarValueChanged:(id)sender {
    
    [self drawImage:((UISlider *)sender).value image:_image];
}

- (IBAction)grayButtonClicked:(id)sender {
    _imageView.image = [self grayImage:_image];
}

- (IBAction)covertToGrayImage:(id)sender {
    _imageView.image = [self covertToGray:_image];
}

/**
 隐藏指定灰度值的像素点
 */
- (void)drawImage:(double)filterValue image:(UIImage *)image
{
    @autoreleasepool {
        // 分配内存
        const int imageWidth = image.size.width;
        const int imageHeight = image.size.height;
        size_t      bytesPerRow = imageWidth * 4;
        //像素将画在这个数组
        uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
        //清空像素数组
        memset(rgbImageBuf, 0, imageWidth*imageHeight*sizeof(uint32_t));
        
        // 创建context
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
        CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
        // 遍历像素
        int pixelNum = imageWidth * imageHeight;
        uint32_t* pCurPtr = rgbImageBuf;
        
        for (int i = 0; i < pixelNum; i++, pCurPtr++)
        {
            // ABGR
            uint8_t* ptr = (uint8_t*)pCurPtr;
            int B = ptr[1];
            int G = ptr[2];
            int R = ptr[3];
            // RGB转灰色的计算公式:
            double Gray = R*0.3+G*0.59+B*0.11;
            if (Gray > filterValue || (Gray == filterValue && filterValue == 0)) {
                ptr[0] = 0;
            }else{
                // ptr[3] = 0xff;
            }
        }
        
        // 将内存转成image
        CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight,NULL);
        CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,NULL, true, kCGRenderingIntentDefault);
        
        CGDataProviderRelease(dataProvider);
        
        UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
        
        // 释放
        CGImageRelease(imageRef);
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        self.imageView.image = resultUIImage;
    }
}

/**
 二值化: 所谓的二值化,其实是将图片的色域空间变为灰色
 */
- (UIImage *)covertToGray:(UIImage *)image{
    
    CGSize size =[image size];
    int width =size.width;
    int height =size.height;
    
    //像素将画在这个数组
    uint32_t *pixels = (uint32_t *)malloc(width *height *sizeof(uint32_t));
    //清空像素数组
    memset(pixels, 0, width*height*sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //用 pixels 创建一个 context
    CGContextRef context =CGBitmapContextCreate(pixels, width, height, 8, width*sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [image CGImage]);
    
    int tt =1;
    CGFloat intensity;
    int bw;
    
    for (int y = 0; y <height; y++) {
        for (int x =0; x <width; x ++) {
            uint8_t *rgbaPixel = (uint8_t *)&pixels[y*width+x];
            intensity = (rgbaPixel[tt] + rgbaPixel[tt + 1] + rgbaPixel[tt + 2]) / 3. / 255.;
            
            bw = intensity > 0.45?255:0;
            
            rgbaPixel[tt] = bw;
            rgbaPixel[tt + 1] = bw;
            rgbaPixel[tt + 2] = bw;
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:imageRef];
    // we're done with image now too
    CGImageRelease(imageRef);
    
    return resultUIImage;
}

/**
 转化灰度
 */
- (UIImage *)grayImage:(UIImage *)image{
    
    int width = image.size.width;
    int height = image.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,      // bits per component
                                                  0,
                                                  colorSpace,
                                                  kCGImageAlphaNone);
    
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height), image.CGImage);
    
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    
    return grayImage;
}

/**
 截取指定区域的图像
 */
-(UIImage *)clipFrom:(UIImage *)image rect:(CGRect)rect{
    //截取部分图片并生成新图片
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    return newImage;
}

@end
