assume cs:code, ds:data, ss:stack

; 栈段
stack segment
    db 100 dup(0)
stack ends  


; 数据段
data segment  
    a dw 0
    db 100 dup(0) 
    string db 'Hello!$'
data ends


; 代码段
code segment
start:
    ; 手动设置ds、ss的值
    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax  
    
    ; 业务逻辑 
    call mathFunc3
    
    mov bx, ax  
    
    ; 退出
    mov ax, 4c00h
    int 21h 
    
; 返回2的3次方
; 返回值放到ax寄存器中     
mathFunc3:  
    mov ax, 2
    add ax, ax
    add ax, ax 
    
    ret 

; 返回2的3次方
; 返回值放到a中     
mathFunc2:  
    mov ax, 2
    add ax, ax
    add ax, ax 
    
    mov a, ax
    
    ret  
    
; 返回2的3次方
; 返回值放到ds:0中     
mathFunc1:  
    mov ax, 2
    add ax, ax
    add ax, ax 
    
    mov [0], ax
    
    ret 
                
code ends  

end start