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
    push 1111h
    push 2222h 
    push 3333h 
    call sum
    add sp, 6     
    
    ; �˳�
    mov ax, 4c00h
    int 21h 
    
; ����ֵ��ax�Ĵ���
; ����2������(����ջ��)    
sum:   
    ; ����ջ�еĲ���
    mov bp, sp
    mov ax, ss:[bp+2]
    add ax, ss:[bp+4]
    add ax, ss:[bp+6]  
    
    ret  
                
code ends  

end start

; �������õı���
; 1.������push ����ֵ
; 2.����ֵ������ֵ��ŵ�ax��
; 3.ջƽ��