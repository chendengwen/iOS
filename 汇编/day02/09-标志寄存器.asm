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
    
    
    mov ax, 11
    mov bx, 11
    sub ax, bx
    
    ; �˳�
    mov ax, 4c00h
    int 21h 
                
code ends  

end start