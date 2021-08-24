
precision mediump float;
varying  vec2 texCoordVarying; // 同于 GPUImage 中的 textureCoordinate
uniform sampler2D sam2DR; // 同于 GPUImage 中的 inputImageTexture

void main(){
    lowp vec4 rgba = vec4(0,0,0,1);
    rgba = texture2D(sam2DR,texCoordVarying);
    gl_FragColor = rgba;
}

/*
 precision 设置float精度，mediump 表示中等还有 lowp 和 highp 可选
 uniform 代表这个变量是需要从程序外部，即应用程序中输入的, uniform 只能输入全局变量，切记.
 */
