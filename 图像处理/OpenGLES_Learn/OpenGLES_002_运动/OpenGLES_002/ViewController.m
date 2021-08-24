/**
 *  学习目标
 *
 *  第一步: 创建EAGContext 跟踪所有状态,命令和资源
 *  第二步: 清除命令
 *  第三步: 创建投影坐标系
 *  第四步: 创建对象坐标
 *  第五步: 导入顶点数据
 *  第六步: 导入颜色数据
 *  第七步: 绘制
 
 设置了
 // 投影矩阵模式
 glMatrixMode(GL_PROJECTION);
 和
 // 模型观察矩阵
 glMatrixMode(GL_MODELVIEW);
 
 就可以不用创建glProgram了吗？？？
 */

#import "ViewController.h"
#import "os_cube.h"
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES1/gl.h>

@interface ViewController ()
@property(nonatomic,strong)EAGLContext *eagContext;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createEagContext];
    [self configure];
    [self setClipping];
}

/**
 *  创建EAGContext 跟踪所有状态,命令和资源
 */
- (void)createEagContext{
    self.eagContext = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES1];
    [EAGLContext setCurrentContext:self.eagContext];
}

/**
 *  配置view
 */
- (void)configure{
    GLKView *view = (GLKView*)self.view;
    // 设置绘图深度 (3D绘图才需要)
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.context = self.eagContext;
}

/**
 *  设置投影坐标的位置及设置窗口
 */
-(void)setClipping{
    // 创建投影坐标
    [self initProjectionMatrix];
    
    float aspectRatio;
    const float zNear = .1; //1
    const float zFar = 1000; //2
    const float fieldOfView = 60.0; //3
    GLfloat     size;
    CGRect frame = [[UIScreen mainScreen] bounds]; //4
    aspectRatio=(float)frame.size.width/(float)frame.size.height; //5
    size = zNear * tanf(GLKMathDegreesToRadians(fieldOfView) / 2.0);
    
    // 设置视图窗口的大小
    glFrustumf(-size, size, -size /aspectRatio, size /aspectRatio, zNear, zFar); //8
    
//    float ratio = (float) frame.size.width / frame.size.height;
//    glFrustumf(-ratio, ratio, -1, 1, 1, 10);
    
    // 设置OpenGL场景的大小
    // 不指定场景的话就默认绘制在 (GLKView*)self.view 上了
//    glViewport(0, 0, frame.size.width, frame.size.height); //9
}

/**
 *  创建投影坐标
 */
- (void)initProjectionMatrix{
    //设置投影矩阵模式
    glMatrixMode(GL_PROJECTION);
    //重置投影矩阵
    glLoadIdentity();
}

#pragma GLKViewController delegate
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [self clear];
    [self initModelViewMatrix];
    [self loadVertexData];
    [self loadColorBuffer];
    [self draw];
}

/**
 *  清除
 */
-(void)clear{
    glEnable(GL_DEPTH_TEST);
    glClearColor(1, 1, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
}

/**
 *  创建物体坐标
 */
-(void)initModelViewMatrix{
    // 选择模型观察矩阵
    glMatrixMode(GL_MODELVIEW);
    // 重置模型观察矩阵
    glLoadIdentity();
    
    static GLfloat transY = 0.0;
    static GLfloat z=-2.0;
    
    static GLfloat spinX=0;
    static GLfloat spinY=0;
    
    // 这两个函数，不论是平移还是旋转都是针对于上一个矩阵来说的
    /*
     void glTranslatef(GLfloat x,GLfloat y,GLfloat z);
     函数功能：
        沿X轴正方向平移x个单位(x是有符号数)
        沿Y轴正方向平移y个单位(y是有符号数)
        沿Z轴正方向平移z个单位(z是有符号数)
     */
    glTranslatef(0.0, (GLfloat)(sinf(transY)/2.0), z);
    
    /*
     void glRotatef(GLfloat angle,GLfloat x,GLfloat y,GLfloat z);
     函数功能：
        以点(0,0,0)到点(x,y,z)为轴，旋转angle角度；
     解释一下旋转方向，做(0,0,0)到(x,y,z)的向量，
     用右手握住这条向量，大拇指指向向量的正方向，四指环绕的方向就是旋转的方向；
     */
    glRotatef(spinY, 0.0, 1.0, 0.0);
    glRotatef(spinX, 1.0, 0.0, 0.0);
    transY += 0.075f;
    spinY+=.25;
    spinX+=.25;
}

/**
 *  导出顶点坐标
 *  glVertexPointer
 *  第一个参数: 每个顶点数据的个数
 *  第二个参数: 顶点数据的数据类型
 *  第三个参数: 偏移量
 *  第四个参数: 顶点数组地址
 */
- (void)loadVertexData{
    glVertexPointer(3, GL_FLOAT, 0, cubeVertices);
    glEnableClientState(GL_VERTEX_ARRAY);
}

/**
 *  导入颜色数据
 *  glColorPointer
 *  第一个参数: 每个Color包含数据的个数
 *  第二个参数: 颜色数据的数据类型
 *  第三个参数: 偏移量
 *  第四个参数: 颜色数组地址
 */
- (void)loadColorBuffer{
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, cubeColors);
    glEnableClientState(GL_COLOR_ARRAY);
}

/**
 *  导入索引数据
 */
-(void)draw{
    // 开启剔除面功能
//    glEnable(GL_CULL_FACE);
    // 剔除背面
//    glCullFace(GL_BACK);
    
    // 根据顶点索引tfan1、tfan2绘制图形, tfan1 绘制3个面，tfan2 绘制3个面
    glDrawElements( GL_TRIANGLE_FAN, sizeof(tfan1), GL_UNSIGNED_BYTE, tfan1);
    glDrawElements( GL_TRIANGLE_FAN, sizeof(tfan2), GL_UNSIGNED_BYTE, tfan2);
}

@end
