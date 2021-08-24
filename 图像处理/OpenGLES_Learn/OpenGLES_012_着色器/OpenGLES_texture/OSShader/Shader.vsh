
attribute vec4 position; // 顶点位置
attribute vec2 texCoord0;// 纹理坐标
varying  vec2 texCoordVarying; //片段着色器的输入变量

void main (){
    texCoordVarying = texCoord0;
    gl_Position = position;
}

/*
 attribute 代表变量是顶点着色器的输入变量
 vec4 4维向量
 varying 代表这个变量是片段着色器的输入变量
 */
