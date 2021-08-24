//
//  OSCube.m
//  OSChart
//
//  Created by xu jie on 16/8/15.
//  Copyright © 2016年 xujie. All rights reserved.
//

#import "OSCube.h"
#import <GLKit/GLKit.h>

@implementation OSCube

+(instancetype)cubeWidthPosition:(OSPosition*)position Width:(GLfloat)width Height:(GLfloat)height Length:(GLfloat)length{
    
    GLfloat x = position.x;
    GLfloat y = position.y;
    GLfloat z = position.z;
    
    // 计算出绘制立方体需要的8个顶点
    OSPosition *position0 = [OSPosition positionMakeX:x-width/2.0 Y:y+height andZ:z+length/2.0];

    OSPosition *position1 = [OSPosition positionMakeX:x+width/2.0 Y:y+height andZ:z+length/2.0];

    OSPosition *position2 = [OSPosition positionMakeX:x-width/2.0 Y:y andZ:z+length/2.0];

    OSPosition *position3 = [OSPosition positionMakeX:x+width/2.0 Y:y andZ:z+length/2.0];
   
    OSPosition *position4 = [OSPosition positionMakeX:x-width/2.0 Y:y+height andZ:z-length/2.0];
    
    OSPosition *position5 = [OSPosition positionMakeX:x+width/2.0 Y:y+height andZ:z-length/2.0];
    
    OSPosition *position6 = [OSPosition positionMakeX:x-width/2.0 Y:y andZ:z-length/2.0];
    
    OSPosition *position7 = [OSPosition positionMakeX:x+width/2.0 Y:y andZ:z-length/2.0];
    
    OSCube* cube = [[OSCube alloc] init];
    cube.number = 216;
    cube.vertex = malloc(sizeof(GLfloat)*cube.number);
    
    NSArray * array = @[position0,position1,position2,position3,position4,position5,position6,position7];
    // 一个立方体有6个面，需要12个三角形
    NSArray * indexs = @[@1,@0,@2,
                         @1,@2,@3,
                         @1,@3,@7,
                         @1,@7,@5,
                         @1,@5,@4,
                         @1,@4,@0,
                         @6,@7,@5,
                         @6,@5,@4,
                         @6,@0,@4,
                         @6,@2,@0,
                         @6,@7,@3,
                         @6,@3,@2];
    
    for (int i=0; i< indexs.count; i++){
        OSPosition *position = array[[indexs[i] integerValue]];
        
        /**
         vertex 指针长度为216，每6个数据分为一组，每个数据长度为 4:CGFloat
         0 1 2 用来存储立方体顶点的空间位置
         3 4 5 用来存储着色器顶点的空间位置
         
         代码中给每个三角形都设置了与三角形平面平行的投影源，即法向全部垂直
         */
        cube.vertex[i*6] = position.x;
        cube.vertex[i*6+1] = position.y;
        cube.vertex[i*6+2] = position.z;
        switch (i/6) {
            case 0:
                cube.vertex[i*6+3] = 0;
                cube.vertex[i*6+4] = 0;
                cube.vertex[i*6+5] = 1;
                break;
            case 1:
                cube.vertex[i*6+3] = 1;
                cube.vertex[i*6+4] = 0;
                cube.vertex[i*6+5] = 0;
                break;
            case 2:
                cube.vertex[i*6+3] = 0;
                cube.vertex[i*6+4] = 1;
                cube.vertex[i*6+5] = 0;
                break;
            case 3:
                cube.vertex[i*6+3] = 0;
                cube.vertex[i*6+4] = 0;
                cube.vertex[i*6+5] = -1;
                break;
            case 4:
                cube.vertex[i*6+3] = 0;
                cube.vertex[i*6+4] = -1;
                cube.vertex[i*6+5] = 0;
                break;
            case 5:
                cube.vertex[i*6+3] = -1;
                cube.vertex[i*6+4] = 0;
                cube.vertex[i*6+5] = 0;
                break;
            default:
                break;
        }
    }

    return cube;
}

-(void)dealloc{
    free(self.vertex);
}

@end
