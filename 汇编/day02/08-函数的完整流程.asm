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
    
    mov si, 1
    mov di, 2
    mov bx, 3 
    mov bp, 4
    
    ; ҵ���߼�
    push 1
    push 2 
    call sum 
    add sp, 4 
    
    ; �˳�
    mov ax, 4c00h
    int 21h 
    
; ����ֵ��ax�Ĵ���
; ����2������(����ջ��)    
sum:
    ; ����bp    
    push bp
    ; ����sp֮ǰ��ֵ��ָ��bp��ǰ��ֵ
    mov bp, sp
    ; Ԥ��10���ֽڵĿռ���ֲ����� 
    sub sp, 10
    
    ; �������ܻ��õ��ļĴ���
    push si
    push di
    push bx 
    
    ; ���ֲ������ռ����int 3��CCCC��
    ; stosw�����ã���ax��ֵ������es:di��,ͬʱdi��ֵ��+2
    mov ax, 0cccch
    ; ��es����ss
    mov bx, ss
    mov es, bx 
    ; ��di����bp-10���ֲ�������ַ��С������
    mov di, bp
    sub di, 10   
    ; cx������stosw��ִ�д���
    mov cx, 5  
    rep stosw  
    ; rep�����ã��ظ�ִ��ĳ��ָ�ִ�д�����cx������
     
    ; -------- ҵ���߼� - begin
    ; ����2���ֲ�����
    mov word ptr ss:[bp-2], 3 
    mov word ptr ss:[bp-4], 4 
    mov ax, ss:[bp-2]
    add ax, ss:[bp-4]
    mov ss:[bp-6], ax 
    
    ; ����ջ�еĲ���
    mov ax, ss:[bp+4]
    add ax, ss:[bp+6] 
    add ax, ss:[bp-6]   
    ; -------- ҵ���߼� - end 
    
    ; �ָ��Ĵ�����ֵ
    pop bx
    pop di
    pop si
                       
    ; �ָ�sp
    mov sp, bp
    ; �ָ�bp
    pop bp
    
    ret 
                
code ends  

end start

; �����ĵ������̣��ڴ棩
; 1.push ����
; 2.push �����ķ��ص�ַ
; 3.push bp ������bp֮ǰ��ֵ�������Ժ�ָ���
; 4.mov bp, sp ������sp֮ǰ��ֵ�������Ժ�ָ���
; 5.sub sp,�ռ��С ������ռ���ֲ�������
; 6.��������Ҫ�õ��ļĴ���
; 7.ʹ��CC��int 3�����ֲ������Ŀռ�  

; 8.--------ִ��ҵ���߼�--------      

; 9.�ָ��Ĵ���֮ǰ��ֵ
; 10.mov sp, bp ���ָ�sp֮ǰ��ֵ��
; 11.pop bp ���ָ�bp֮ǰ��ֵ��
; 12.ret ���������ķ��ص�ַ��ջ��ִ����һ��ָ�
; 13.�ָ�ջƽ�� ��add sp,������ռ�Ŀռ䣩