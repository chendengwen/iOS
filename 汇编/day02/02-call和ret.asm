assume cs:code, ds:data, ss:stack

; ջ��
stack segment
    db 100 dup(0)
stack ends  


; ���ݶ�
data segment 
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
    call print
    
    mov ax, 1122h
    mov bx, 3344h
    add ax, bx  
    
    ; �˳�
    mov ax, 4c00h
    int 21h 
    
; ��ӡ�ַ���    
print:    

    ; ds:dx��֪�ַ�����ַ    
    mov dx, offset string
    mov ah, 9h
    int 21h
    
    ret 
                
code ends  

end start 

; ������Ҫ��
; 1.����
; 2.����ֵ
; 3.�ֲ�����