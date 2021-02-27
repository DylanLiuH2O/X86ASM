         jmp near start
 message db '1+2+3+...+100='

  start:
         mov ax,0x07c0
         mov ds,ax

         mov ax,0xb800
         mov es,ax

         ;-----
         mov cx,start-message
         mov si,message
         mov di,0
     @g:
         mov ax,[ds:si]
         mov [es:di],ax
         inc di
         mov byte [es:di],0x07
         inc si
         inc di
         loop @g

         ;-----
         mov ax,0
         mov cx,1
     @h:
         add ax,cx
         inc cx
         cmp cx,100
         jng @h

         ;-----
         mov cx,0x0000
         mov ss,cx
         mov sp,cx
         mov bx,10
     @i:
         xor dx,dx
         div bx 
         add dl,'0'
         push dx
         inc cx
         cmp ax,0
         jne @i

         ;-----
     @j:
         pop dx
         mov [es:di],dx
         inc di
         mov byte [es:di],0x07
         inc di
         loop @j

         jmp near $

times 510-($-$$) db 0
                 db 0x55,0xaa