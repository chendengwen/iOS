assume cs:code, ds:data

; ���ݶ�
data segment
    db 40, 41, 42, 64, 'Hello World!$' 
data ends

; �����
code segment   
start:    
    ; ����ds��ֵ
    mov ax, data
    mov ds, ax  
    
    ; ��ӡ�ַ��� 
    mov dx, 0h
    mov ah, 9h
    int 21h

    ; �˳�����
    mov ax, 4c00h
    int 21h
code ends  

end start