assume cs:code, ds:data

; 数据段
data segment
    db 40, 41, 42, 64, 'Hello World!$' 
data ends

; 代码段
code segment   
start:    
    ; 设置ds的值
    mov ax, data
    mov ds, ax  
    
    ; 打印字符串 
    mov dx, 0h
    mov ah, 9h
    int 21h

    ; 退出程序
    mov ax, 4c00h
    int 21h
code ends  

end start