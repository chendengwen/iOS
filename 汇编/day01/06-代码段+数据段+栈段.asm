assume cs:code, ds:data, ss:stack

; ջ��
stack segment   
    db 10 dup(8)
stack ends 

; ���ݶ�
data segment   
    db 20 dup(9)
data ends 

; �����
code segment
start: 
    ; �ֶ�����ss��ds
    mov ax, stack
    mov ss, ax   
    mov ax, data
    mov ds, ax

    mov ax, 1122h
    mov bx, 3344h  
    
    mov [0], ax
    
    ; ʹ��ջ
    mov sp, 10 
    push ax
    push bx
    pop ax
    pop bx
    
    
    ; �˳�
    mov ax, 4c00h
    int 21h   
code ends

end start