assume cs:code, ds:data, ss:stack

; ջ��
stack segment
    db 100 dup(0)
stack ends  


; ���ݶ�
data segment  
    a dw 0
    db 100 dup(0) 
    string db 'Hello!$'
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
    call mathFunc3
    
    mov bx, ax  
    
    ; �˳�
    mov ax, 4c00h
    int 21h 
    
; ����2��3�η�
; ����ֵ�ŵ�ax�Ĵ�����     
mathFunc3:  
    mov ax, 2
    add ax, ax
    add ax, ax 
    
    ret 

; ����2��3�η�
; ����ֵ�ŵ�a��     
mathFunc2:  
    mov ax, 2
    add ax, ax
    add ax, ax 
    
    mov a, ax
    
    ret  
    
; ����2��3�η�
; ����ֵ�ŵ�ds:0��     
mathFunc1:  
    mov ax, 2
    add ax, ax
    add ax, ax 
    
    mov [0], ax
    
    ret 
                
code ends  

end start