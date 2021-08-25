assume cs:code, ds:data, ss:stack

; 栈段
stack segment
    db 100 dup(0)
stack ends  


; 数据段
data segment  
    db 100 dup(0) 
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
    push 1122h
    push 3344h 
    call sum
    add sp, 4  
    
    push 1122h
    push 3344h  
    call minus   
    
    ; 退出
    mov ax, 4c00h
    int 21h 
    
; 返回值放ax寄存器
; 传递2个参数(放入栈中)    
sum:   
    ; 访问栈中的参数
    mov bp, sp
    mov ax, ss:[bp+2]
    add ax, ss:[bp+4]
    
    ret 
        
; 返回值放ax寄存器
; 传递2个参数(放入栈中)   
minus:
    mov bp, sp 
    mov ax, ss:[bp+2]
    sub ax, ss:[bp+4]
     
    ret 4
    
    
                
code ends  

end start

; 栈平衡：函数调用前后的栈顶指针要一致
; 栈如果不平衡的结果：栈空间迟早会被用完

; 栈平衡的方法
; 1.外平栈
;    push 1122h
;    push 3344h 
;    call sum
;    add sp, 4 
; 2.内平栈
;    ret 4