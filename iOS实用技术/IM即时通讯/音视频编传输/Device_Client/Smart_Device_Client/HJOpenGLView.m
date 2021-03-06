//
//  HJOpenGLView.m
//  Smart_Device_Client
//
//  Created by Josie on 2017/9/22.
//  Copyright © 2017年 Josie. All rights reserved.
//

#import "HJOpenGLView.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVUtilities.h>
#import <mach/mach_time.h>
#import <GLKit/GLKit.h>
#import "HeaderDefine.h"

// Uniform index.
enum {
	UNIFORM_Y,
	UNIFORM_UV,
	UNIFORM_COLOR_CONVERSION_MATRIX,
	NUM_UNIFORMS
};

// 定义uniform数组 uniforms[3]
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum {
	ATTRIB_VERTEX,
	ATTRIB_TEXCOORD,
	NUM_ATTRIBUTES
};

// Color Conversion Constants (YUV to RGB) including adjustment from 16-235/16-240 (video range)
// 颜色转换常数（YUV到RGB）包括16-235 / 16-240调整（视频系列）

// BT.601, which is the standard for SDTV.
static const GLfloat kColorConversion601[] = {
		1.164,  1.164, 1.164,
		  0.0, -0.392, 2.017,
		1.596, -0.813,   0.0,
};

// BT.709, which is the standard for HDTV.
static const GLfloat kColorConversion709[] = {
		1.164,  1.164, 1.164,
		  0.0, -0.213, 2.112,
		1.793, -0.533,   0.0,
};

// BT.601 full range (ref: http://www.equasys.de/colorconversion.html)
const GLfloat kColorConversion601FullRange[] = {
    1.0,    1.0,    1.0,
    0.0,    -0.343, 1.765,
    1.4,    -0.711, 0.0,
};


@interface HJOpenGLView ()
{
	// 像素尺寸 of the CAEAGLLayer.
	GLint           _backingWidth;
	GLint           _backingHeight;

	EAGLContext                 *_context;  // 绘制句柄或者上下文
	CVOpenGLESTextureRef        _lumaTexture; // 亮度 Y
	CVOpenGLESTextureRef        _chromaTexture; // 色彩浓度 UV
	CVOpenGLESTextureCacheRef   _videoTextureCache; // 纹理绘制缓冲区，需要绘制的纹理都绑定在上面
	
	GLuint          _frameBufferHandle;
	GLuint          _colorBufferHandle;
	
	const GLfloat   *_preferredConversion;
    
    BOOL            _isFullScreen;
    
}

@property GLuint program;

- (void)setupBuffers;
- (void)cleanUpTextures;

- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type URL:(NSURL *)URL;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;

@end

@implementation HJOpenGLView

/*
    CAEAGLLayer提供了一个OpenGLES渲染环境。
    各种各样的OpenGL绘图缓冲的底层可配置项仍然需要你用CAEAGLLayer完成，
    它是CALayer的一个子类，用来显示任意的OpenGL图形。
 */
+ (Class)layerClass{
	return [CAEAGLLayer class];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
        _isFullScreen = NO;
        
        self.contentScaleFactor = [[UIScreen mainScreen] scale];
        //        self.contentScaleFactor = [self.frame scale];
        
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = TRUE;
        eaglLayer.drawableProperties = @{ kEAGLDrawablePropertyRetainedBacking :[NSNumber numberWithBool:NO],
                                          kEAGLDrawablePropertyColorFormat : kEAGLColorFormatRGBA8};
        
        // 初始化EAGLContext时指定ES版本号
        _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        
        if (!_context || ![EAGLContext setCurrentContext:_context] || ![self loadShaders]) {
            return nil;
        }
        
        _preferredConversion = kColorConversion709;
    }
    return self;
}

# pragma mark - OpenGL setup
- (void)setupGL{
	[EAGLContext setCurrentContext:_context];
	[self setupBuffers];
	[self loadShaders];
	
	glUseProgram(self.program);
	
    /*
     设置这三个采样器
     */
    // 纹理采样器设置
    // 0 表示第一层纹理: GL_TEXTURE0
    // 1 表示第二层纹理: GL_TEXTURE1
	glUniform1i(uniforms[UNIFORM_Y], 0); //采样器 SamplerY
	glUniform1i(uniforms[UNIFORM_UV], 1); //采样器 SamplerUV
    // 将颜色转换矩阵参数 _preferredConversion 设置到对应的采样器中
	glUniformMatrix3fv(uniforms[UNIFORM_COLOR_CONVERSION_MATRIX], 1, GL_FALSE, _preferredConversion); //采样器 colorConversionMatrix
	
	// Create CVOpenGLESTextureCacheRef for optimal CVPixelBufferRef to GLES texture conversion.
	if (!_videoTextureCache) {
		CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, _context, NULL, &_videoTextureCache);
		if (err != noErr) {
			NSLog(@"Error at CVOpenGLESTextureCacheCreate %d", err);
			return;
		}
	}
}

#pragma mark - Utilities
- (void)setupBuffers{
	glDisable(GL_DEPTH_TEST);
	
    /*
     顶点数据组的数据传递给GPU
     void glVertexAttribPointer(GLuint index,
                                GLint size,     //每个属性元素个数有效值1-4（x,y,z,w）
                                GLenum type, //数组中每个元素的数据类型
                                GLboolean normalized,
                                GLsizei stride, //如果数据连续存放，则为0或size*sizeof(type)
                                const void *ptr)  //顶点数组指针
     */
	glEnableVertexAttribArray(ATTRIB_VERTEX);
	glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, GL_FALSE, 2 * sizeof(GLfloat), 0);
	
	glEnableVertexAttribArray(ATTRIB_TEXCOORD);
	glVertexAttribPointer(ATTRIB_TEXCOORD, 2, GL_FLOAT, GL_FALSE, 2 * sizeof(GLfloat), 0);
	
	glGenFramebuffers(1, &_frameBufferHandle);              // 创建帧缓冲区
	glBindFramebuffer(GL_FRAMEBUFFER, _frameBufferHandle);  // 绑定帧缓冲区到渲染管线
	
	glGenRenderbuffers(1, &_colorBufferHandle);             // 创建绘制缓冲区
	glBindRenderbuffer(GL_RENDERBUFFER, _colorBufferHandle);// 绑定绘制缓冲区到渲染管线
	
    // 为绘制缓冲区分配存储区，此处将CAEAGLLayer的绘制存储区作为绘制缓冲区的存储区
	[_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
    // 获取绘制缓冲区的像素宽度和高度
	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_backingWidth);
	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_backingHeight);
    
    // 绑定绘制缓冲区到帧缓冲区
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorBufferHandle);
	if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
		NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
	}
}

#pragma mark - OpenGLES drawing
- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer  // ---- pixelBuffer:解码后的视频数据 ----
{
    // pixelBuffer理解成视频的一个帧，即一张图片
    
	CVReturn err;
	if (pixelBuffer != NULL) {
		int frameWidth = (int)CVPixelBufferGetWidth(pixelBuffer);
		int frameHeight = (int)CVPixelBufferGetHeight(pixelBuffer);
//        printf("--- frame width = %d, height = %d -----\n", frameWidth, frameHeight);
        
		if (!_videoTextureCache) {
			NSLog(@"No video texture cache");
			return;
		}
        if ([EAGLContext currentContext] != _context) {
            [EAGLContext setCurrentContext:_context]; // 非常重要的一行代码
        }
		[self cleanUpTextures];
		
		/*
         使用像素缓冲区的颜色附件来确定适当的颜色转换矩阵。
		 */
//        CFTypeRef colorAttachments = CVBufferGetAttachment(pixelBuffer, kCVImageBufferYCbCrMatrixKey, NULL);
        // YCbCr->RGB
        _preferredConversion = kColorConversion601FullRange;
		
		/*
         从像素缓冲区创建Y和UV纹理。这些纹理将被绘制在帧缓冲平面。
         */
        // Y-plane.
        // 将 pixelBuffer 图像数据的 GL_LUMINANCE 亮度数据绘制在 _lumaTexture 亮度纹理上，
        // 此时  _lumaTexture 对应着第一层纹理
		glActiveTexture(GL_TEXTURE0);
		err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
														   _videoTextureCache,
														   pixelBuffer,
														   NULL,
														   GL_TEXTURE_2D,
														   GL_LUMINANCE,
														   frameWidth,
														   frameHeight,
														   GL_LUMINANCE,
														   GL_UNSIGNED_BYTE,
														   0,
														   &_lumaTexture);
		if (err) {
			NSLog(@"Error at CVOpenGLESTextureCacheCreateTextureFromImage %d", err);
		}
		
        // 绑定纹理到context. glBindTexture(纹理类型, 纹理id)
        glBindTexture(CVOpenGLESTextureGetTarget(_lumaTexture), CVOpenGLESTextureGetName(_lumaTexture));
        
        // 设置纹理采样方式
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
		
		// UV-plane.
        // 将 pixelBuffer 图像数据的 GL_LUMINANCE_ALPHA 色彩浓度数据绘制在 _chromaTexture 色彩浓度纹理上，
        // 此时  _chromaTexture 对应着第二层纹理
		glActiveTexture(GL_TEXTURE1);
		err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
														   _videoTextureCache,
														   pixelBuffer,
														   NULL,
                                                           GL_TEXTURE_2D,
                                                           GL_LUMINANCE_ALPHA,
                                                           frameWidth / 2,
                                                           frameHeight / 2,
                                                           GL_LUMINANCE_ALPHA,
														   GL_UNSIGNED_BYTE,
														   1,
														   &_chromaTexture);
		if (err) {
			NSLog(@"Error at CVOpenGLESTextureCacheCreateTextureFromImage %d", err);
		}
		
		glBindTexture(CVOpenGLESTextureGetTarget(_chromaTexture), CVOpenGLESTextureGetName(_chromaTexture));
//        NSLog(@"id %d", CVOpenGLESTextureGetName(_chromaTexture));
        
        // 设置纹理采样方式
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
		
        // 以上设置好帧相关的数据后将帧缓冲区绑定到渲染管线
        // 1. 渲染管线会在帧缓存区提取数据，而缓冲区则从纹理上取样获取数据
        // 2. 纹理数据缓存在 _videoTextureCache 中，
		glBindFramebuffer(GL_FRAMEBUFFER, _frameBufferHandle);

		glViewport(0, 0, _backingWidth, _backingHeight);
	}
	
	glClearColor(0.1f, 0.0f, 0.0f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT);
	
	// 使用着色器
	glUseProgram(self.program);
    
	glUniformMatrix3fv(uniforms[UNIFORM_COLOR_CONVERSION_MATRIX], 1, GL_FALSE, _preferredConversion);
	
	// 设置四顶点相对于视频的方向和长宽比。
	CGRect vertexSamplingRect = AVMakeRectWithAspectRatioInsideRect(CGSizeMake(_backingWidth, _backingHeight), self.layer.bounds);
    
	// 计算标准化的四个坐标来绘制帧。
	CGSize normalizedSamplingSize = CGSizeMake(0.0, 0.0);
	CGSize cropScaleAmount = CGSizeMake(vertexSamplingRect.size.width/self.layer.bounds.size.width, vertexSamplingRect.size.height/self.layer.bounds.size.height);
    
	// 规范四边形顶点。
	if (cropScaleAmount.width > cropScaleAmount.height) {
		normalizedSamplingSize.width = 1.0;
		normalizedSamplingSize.height = cropScaleAmount.height/cropScaleAmount.width;
	} else {
		normalizedSamplingSize.width = 1.0;
		normalizedSamplingSize.height = cropScaleAmount.width/cropScaleAmount.height;
	}
    
	/*
      四顶点数据定义了我们绘制像素缓冲区的二维平面区域。
     顶点数据分别用（-1，-1）和（1，1）作为左下角和右上角坐标，覆盖整个屏幕。
     */
    GLfloat quadVertexData [] = {
        -1 , -1 ,
         1 , -1,
        -1 ,  1,
         1 ,  1,
    };
	
	// 更新顶点数据
	glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, quadVertexData);
	glEnableVertexAttribArray(ATTRIB_VERTEX);
    
    // 纹理坐标
    GLfloat quadTextureData[] =  {
        1, 0,
        0, 0,
        1, 1,
        0, 1
    };
	
	glVertexAttribPointer(ATTRIB_TEXCOORD, 2, GL_FLOAT, 0, 0, quadTextureData);
	glEnableVertexAttribArray(ATTRIB_TEXCOORD);
	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

	glBindRenderbuffer(GL_RENDERBUFFER, _colorBufferHandle);
    
    if ([EAGLContext currentContext] == _context) {
        [_context presentRenderbuffer:GL_RENDERBUFFER];
    }
}

#pragma mark -  OpenGL ES 2 shader compilation
- (BOOL)loadShaders{
	GLuint vertShader, fragShader;
	NSURL *vertShaderURL, *fragShaderURL;
	
	self.program = glCreateProgram();
	
	// 创建并编译顶点着色器。
	vertShaderURL = [[NSBundle mainBundle] URLForResource:@"Shader" withExtension:@"vsh"];
	if (![self compileShader:&vertShader type:GL_VERTEX_SHADER URL:vertShaderURL]) {
		NSLog(@"Failed to compile vertex shader");
		return NO;
	}
	
	// 创建和编译帧着色器(fragment shader)。
	fragShaderURL = [[NSBundle mainBundle] URLForResource:@"Shader" withExtension:@"fsh"];
	if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER URL:fragShaderURL]) {
		NSLog(@"Failed to compile fragment shader");
		return NO;
	}
	
	// Attach vertex shader to program.   附上顶点着色器
	glAttachShader(self.program, vertShader);
	
	// Attach fragment shader to program. 附上帧着色器
	glAttachShader(self.program, fragShader);
	
    /*
     指定需要用到的顶点属性
     在OpenGL ES1.1中，顶点属性有四个预定义的名字：
     position（位置）, normal（法线）, color（颜色）, 和 texture coordinates（纹理坐标）
     在OpenGL ES2.0中，用户必须定义“顶点属性的名字”。
     */
	// Bind attribute locations. This needs to be done prior(优先于) to linking.
	glBindAttribLocation(self.program, ATTRIB_VERTEX, "position");
	glBindAttribLocation(self.program, ATTRIB_TEXCOORD, "texCoord");
	
	// Link the program.
	if (![self linkProgram:self.program]) {
		NSLog(@"Failed to link program: %d", self.program);
		
		if (vertShader) {
			glDeleteShader(vertShader);
			vertShader = 0;
		}
		if (fragShader) {
			glDeleteShader(fragShader);
			fragShader = 0;
		}
		if (self.program) {
			glDeleteProgram(self.program);
			self.program = 0;
		}
		
		return NO;
	}
	
	// 获取着色器里指定名称的采样器的地址
	uniforms[UNIFORM_Y] = glGetUniformLocation(self.program, "SamplerY");
	uniforms[UNIFORM_UV] = glGetUniformLocation(self.program, "SamplerUV");
	uniforms[UNIFORM_COLOR_CONVERSION_MATRIX] = glGetUniformLocation(self.program, "colorConversionMatrix");
	
	// Release vertex and fragment shaders.
	if (vertShader) {
		glDetachShader(self.program, vertShader);
		glDeleteShader(vertShader);
	}
	if (fragShader) {
		glDetachShader(self.program, fragShader);
		glDeleteShader(fragShader);
	}
	
	return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type URL:(NSURL *)URL{
    NSError *error;
    NSString *sourceString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:&error];
    if (sourceString == nil) {
		NSLog(@"Failed to load vertex shader: %@", [error localizedDescription]);
        return NO;
    }
    
	GLint status;
	const GLchar *source;
	source = (GLchar *)[sourceString UTF8String];
	
	*shader = glCreateShader(type);
	glShaderSource(*shader, 1, &source, NULL);
	glCompileShader(*shader);
	
#if defined(DEBUG)
	GLint logLength;
	glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
	if (logLength > 0) {
		GLchar *log = (GLchar *)malloc(logLength);
		glGetShaderInfoLog(*shader, logLength, &logLength, log);
		NSLog(@"Shader compile log:\n%s", log);
		free(log);
	}
#endif
	
	glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
	if (status == 0) {
		glDeleteShader(*shader);
		return NO;
	}
	
	return YES;
}

- (BOOL)linkProgram:(GLuint)prog{
	GLint status;
	glLinkProgram(prog);
	
#if defined(DEBUG)
	GLint logLength;
	glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
	if (logLength > 0) {
		GLchar *log = (GLchar *)malloc(logLength);
		glGetProgramInfoLog(prog, logLength, &logLength, log);
		NSLog(@"Program link log:\n%s", log);
		free(log);
	}
#endif
	
	glGetProgramiv(prog, GL_LINK_STATUS, &status);
	if (status == 0) {
		return NO;
	}
	
	return YES;
}

- (BOOL)validateProgram:(GLuint)prog{
	GLint logLength, status;
	
	glValidateProgram(prog);
	glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
	if (logLength > 0) {
		GLchar *log = (GLchar *)malloc(logLength);
		glGetProgramInfoLog(prog, logLength, &logLength, log);
		NSLog(@"Program validate log:\n%s", log);
		free(log);
	}
	
	glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
	if (status == 0) {
		return NO;
	}
	
	return YES;
}

#pragma mark -  CleanUp
- (void)cleanUpTextures{
    if (_lumaTexture) {
        CFRelease(_lumaTexture);
        _lumaTexture = NULL;
    }
    
    if (_chromaTexture) {
        CFRelease(_chromaTexture);
        _chromaTexture = NULL;
    }
    
    // Periodic texture cache flush every frame.   Periodic:周期的;  flush:刷新;
    CVOpenGLESTextureCacheFlush(_videoTextureCache, 0);
}

- (void)dealloc{
    [self cleanUpTextures];
    
    if(_videoTextureCache) {
        CFRelease(_videoTextureCache);
    }
    
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didClickFullButton" object:nil];
}

@end

