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
    call sum
    add sp, 4  
    
    push 1122h
    push 3344h  
    call minus   
    
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
    
    ret 
        
; ����ֵ��ax�Ĵ���
; ����2������(����ջ��)   
minus:
    mov bp, sp 
    mov ax, ss:[bp+2]
    sub ax, ss:[bp+4]
     
    ret 4
    
    
                
code ends  

end start

; ջƽ�⣺��������ǰ���ջ��ָ��Ҫһ��
; ջ�����ƽ��Ľ����ջ�ռ����ᱻ����

; ջƽ��ķ���
; 1.��ƽջ
;    push 1122h
;    push 3344h 
;    call sum
;    add sp, 4 
; 2.��ƽջ
;    ret 4