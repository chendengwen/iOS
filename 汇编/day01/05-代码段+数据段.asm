; ���ѿ�����ÿ���εĺ���
assume cs:code, ds:data
 
  
; ----- ���ݶ� begin ----- 
data segment            
    age db 20h
    no dw 30h 
    db 10 dup(6) ; ����10��������6 
    string db 'Hello World!$'  
data ends  
; ----- ���ݶ� end ----- 


; ----- ����� begin ----- 
code segment  
start:     
    ; �ֶ�����ds��ֵ
    mov ax, data
    mov ds, ax
    
    mov ax, no
    mov bl, age

    ; ��ӡ
    mov dx, offset string 
    ; offset string����string��ƫ�Ƶ�ַ   
    mov ah, 9h
    int 21h 
    
    ; �˳�
    mov ax, 4c00h
    int 21h    
code ends
; ----- ����� end -----    
   
   
; ���������start�ǳ������
; start���ڵĶξ��Ǵ����
; ����cs��ֵ����code�εĶε�ַ
; �൱��cs��ֵ�Ѿ��Զ��������
end start