assume cs:code, ds:data, ss:stack

; ջ��
stack segment
    db 100 dup(0)
stack ends  


; ���ݶ�
data segment  
    db 100 dup(0) 
data ends


; �����
code segment
start:
    ; �ֶ�����ds��ss��ֵ
    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax  
    
    ; ҵ���߼�
    push 1122h
    push 3344h 
    call sum3 
    add sp, 4
    
    push 2222h
    push 2222h 
    call sum3
    add sp, 4
    
    push 3333h
    push 3333h 
    call sum3
    add sp, 4
     
    mov cx, 1122h 
    mov dx, 2233h 
    call sum1 
    
    mov word ptr [0], 1122h 
    mov word ptr [2], 2233h 
    call sum2  
    
    ; �˳�
    mov ax, 4c00h
    int 21h 
    
; ����ֵ��ax�Ĵ���
; ����2������(����ջ��)    
sum3:   
    ; ����ջ�еĲ���
    mov bp, sp
    mov ax, ss:[bp+2]
    add ax, ss:[bp+4]
    ret 
          
; ����ֵ��ax�Ĵ���
; ����2������(�ֱ��ds:0��ds:2)    
sum2:         
    mov ax, [0]
    add ax, [2]
    ret 
            
; ����ֵ��ax�Ĵ���
; ����2���������ֱ��cx��dx�У�    
sum1:  
    mov ax, cx
    add ax, dx
    ret 
                
code ends  

end start

; ջƽ�⣺��������ǰ���ջ��ָ��Ҫһ��
; ջ�����ƽ��Ľ����ջ�ռ����ᱻ����