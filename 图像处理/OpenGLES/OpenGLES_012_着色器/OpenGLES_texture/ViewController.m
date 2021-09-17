//
//  ViewController.m
//  OpenGLES_texture
//
//  Created by xu jie on 16/8/22.
//  Copyright © 2016年 xujie. All rights reserved.
//

#import "ViewController.h"
#import "OSShaderManager.h"

/**
 demo详解
 https://www.jianshu.com/p/18d6b37363c8
*/

/** 顶点坐标
 4个顶点
 
 (-1,1)v0           (1,1)v1
 
            (0,0)
 
 (-1,-1)v2          (1,-1)v3
 */
static GLfloat vertex[8] = {
     1,1,  //v1
    -1,1,  //v0
    -1,-1, //v2
     1,-1, //v3
};

/** 纹理坐标  纹理坐标系S 轴和 T 轴的取值范围都为[0,1]
 4个顶点

 1-------1,1    (0,1)v0    (1,1)v1
 |       |
 |       |
 0-------1      (0,0)v2    (1,0)v3
 */
static GLfloat textureCoords[8] = {
    1,1,
    0,1,
    0,0,
    1,0
};

@interface ViewController ()
{
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    
    GLuint _textureCoordBuffer;
    GLuint _textureBufferR;
    GLuint _textureBufferGB;
    
    GLuint _text2D;
}

@property(nonatomic,strong) OSShaderManager *shaderManager;
@property(nonatomic,strong) EAGLContext *eagContext;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup]; //初始化
    [self loadVertex]; // 加载顶点
    [self loadTexture]; // 加载纹理
}

-(void)setup{
    self.eagContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:self.eagContext];
    
    GLKView *view = (GLKView*)self.view;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.context = self.eagContext;
    
    self.shaderManager = [[OSShaderManager alloc] init];
    // 编译链接 shader 文件
    GLuint vertexShader,fragmentShader;
    NSURL *vertexShaderPath = [[NSBundle mainBundle] URLForResource:@"Shader" withExtension:@"vsh"];
    NSURL *fragmentShaderPath = [[NSBundle mainBundle] URLForResource:@"Shader" withExtension:@"fsh"];
    if (![self.shaderManager compileShader:&vertexShader type:GL_VERTEX_SHADER URL:vertexShaderPath]||![self.shaderManager compileShader:&fragmentShader type:GL_FRAGMENT_SHADER URL:fragmentShaderPath]){
        return ;
    }
    // 注意获取绑定属性要在连接程序之前
    [self.shaderManager bindAttribLocation:GLKVertexAttribPosition andAttribName:"position"];
    [self.shaderManager bindAttribLocation:GLKVertexAttribTexCoord0 andAttribName:"texCoord0"];
    
    // 将编译好的两个对象和着色器程序进行连接
    if(![self.shaderManager linkProgram]){
        [self.shaderManager deleteShader:&vertexShader];
        [self.shaderManager deleteShader:&fragmentShader];
    }
    
    // 从着色器中读取文理采样器（uniform sampler2D sam2DR）
    _textureBufferR = [self.shaderManager getUniformLocation:"sam2DR"];
    
    // 接触
    [self.shaderManager detachAndDeleteShader:&vertexShader];
    [self.shaderManager detachAndDeleteShader:&fragmentShader];
    [self.shaderManager useProgram];
}

-(void)loadVertex{
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES( _vertexArray);
    
    // 加载顶点坐标生成缓冲区
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertex), &vertex, GL_STATIC_DRAW);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 8, NULL);
    
    /* 加载纹理坐标生成缓冲区 */
    // 第一步.在GPU 中先申请一个内存标识
    glGenBuffers(1, &_textureCoordBuffer);
    // 第二步.让这个标识去绑定一个内存区域，但是此时，这个内存没有大小.
    glBindBuffer(GL_ARRAY_BUFFER, _textureCoordBuffer);
    // 第三步.根据顶点数组的大小，开辟内存空间，并将数据加载到内存中
    glBufferData(GL_ARRAY_BUFFER, sizeof(textureCoords), textureCoords, GL_STATIC_DRAW);
    // 第四步 .启用这块内存，标记为位置
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    // 第五步.告诉GPU顶点数据在内存中的格式是怎么样的，应该如何去使用
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 8, NULL);
    
    glEnableVertexAttribArray(_vertexArray);
}

-(void)loadTexture{
    //第一步.将我们着色器中的纹理采样器和纹理区域0进行关联.
    glUniform1i(_textureBufferR, 0); // 0 代表GL_TEXTURE0
    GLuint tex1;
    //第二步.激活纹理区域0
    glActiveTexture(GL_TEXTURE0);
    //第三步. 申请内存标识,
    /* 使用纹理之前，必须执行这句命令为你的texture分配一个ID，
     然后绑定这个纹理，加载纹理图像，这之后，这个纹理才可以使用
     https://blog.csdn.net/andy20081251/article/details/42739357*/
    glGenTextures(1, &tex1);
    //第四步. 将内存和激活的纹理区域绑定
    glBindTexture(GL_TEXTURE_2D,  tex1);
    
    UIImage *image = [UIImage imageNamed:@"2.png"];
    GLubyte *imageData = [self getImageData:image];
    
    //第五步.将图片像素数据，加载到纹理区域0 中去
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA , image.size.width, image.size.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    free(imageData);
    
    /*
     TextureParameterName
     
     GL_TEXTURE_MAG_FILTER                            0x2800
     GL_TEXTURE_MIN_FILTER                            0x2801
     GL_TEXTURE_WRAP_S                                0x2802
     GL_TEXTURE_WRAP_T                                0x2803
     */
    //第六步.设置图片在渲染时的采样方式
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
}

/**
 *  获取图片数据的像素数据RGBA
 *  @param image 图片
 *  @return 像素数据
 */
- (void*)getImageData:(UIImage*)image{
    CGImageRef imageRef = [image CGImage];
    size_t imageWidth = CGImageGetWidth(imageRef);
    size_t imageHeight = CGImageGetHeight(imageRef);
    GLubyte *imageData = (GLubyte *)malloc(imageWidth*imageHeight*4);
    memset(imageData, 0,imageWidth *imageHeight*4);
    CGContextRef imageContextRef = CGBitmapContextCreate(imageData, imageWidth, imageHeight, 8, imageWidth*4, CGImageGetColorSpace(imageRef), kCGImageAlphaPremultipliedLast);
    CGContextTranslateCTM(imageContextRef, 0, imageHeight);
    CGContextScaleCTM(imageContextRef, 1.0, -1.0);
    CGContextDrawImage(imageContextRef, CGRectMake(0.0, 0.0, (CGFloat)imageWidth, (CGFloat)imageHeight), imageRef);
    CGContextRelease(imageContextRef);
    return  imageData;
}

#pragma GLKViewController delegate
/**
 最后一步 绘制
 */
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    // 设置清除颜色
    glClearColor(1, 1, 1, 1);
    // 清除颜色缓冲区
    glClear(GL_COLOR_BUFFER_BIT);
    
    /*
     使用着色器程序绘制
     */
//    // 使用着色器程序
//    [self.shaderManager useProgram];
//    // 绘制  GL_TRIANGLE_FAN 是绘制方式
//    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);

    
    /*
     glDrawArrays(GL_TRIANGLE_FAN, 0, 4)
                                   0 ---- 顶点在坐标数组中的起始位置索引为0
                                   4 ---- 顶点的个数
     以 glView 的第 0 个顶点开始的 4 顶点绘制
     
     绘制的是3个顶点，即三角形
     glDrawArrays(GL_TRIANGLE_FAN, 0, 3);
     glDrawArrays(GL_TRIANGLE_FAN, 1, 4);
     */
    glViewport(0, 0, 100, 100);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    
    /*
     使用glViewport绘制并指定绘图区域
     */
    glViewport(150, 100, 100, 100);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    
}

@end
