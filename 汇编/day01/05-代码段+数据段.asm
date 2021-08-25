; 提醒开发者每个段的含义
assume cs:code, ds:data
 
  
; ----- 数据段 begin ----- 
data segment            
    age db 20h
    no dw 30h 
    db 10 dup(6) ; 生成10个连续的6 
    string db 'Hello World!$'  
data ends  
; ----- 数据段 end ----- 


; ----- 代码段 begin ----- 
code segment  
start:     
    ; 手动设置ds的值
    mov ax, data
    mov ds, ax
    
    mov ax, no
    mov bl, age

    ; 打印
    mov dx, offset string 
    ; offset string代表string的偏移地址   
    mov ah, 9h
    int 21h 
    
    ; 退出
    mov ax, 4c00h
    int 21h    
code ends
; ----- 代码段 end -----    
   
   
; 编译结束，start是程序入口
; start所在的段就是代码段
; 所以cs的值就是code段的段地址
; 相当于cs的值已经自动设置完毕
end start