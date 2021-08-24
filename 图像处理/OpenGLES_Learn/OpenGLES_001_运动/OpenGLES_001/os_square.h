//
//  os_square.h
//  OpenGLES_002
//
//  Created by xu jie on 16/8/6.
//  Copyright © 2016年 xujie. All rights reserved.
//

#ifndef os_square_h
#define os_square_h

//正方形的4个顶点
static const GLfloat squareVertices[] = {
    -0.5, -0.33,
     0.5, -0.33,
    -0.5,  0.33,
     0.5,  0.33,
};

//4个颜色
static const GLubyte squareColors[] = {
    255,   0,   0, 255,
      0, 255,   0, 255,
      0, 255,   0, 255,
    255,   0, 255, 255,
};


#endif /* os_square_h */
