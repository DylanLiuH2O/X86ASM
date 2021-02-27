         jmp near start
  string db '1+2+3+...+100='

  start: 
         mov ax,0x07c0
         mov ds,ax

         mov ax,0xb800
         mov es,ax

         mov cx,start-string
         mov si,string
         mov di,0
     @g:
         mov ax,[ds:si]
         mov [es:di],ax
         inc di
         mov byte [es:di],0x07
         inc si
         inc di
         loop @g

         jmp near $

times 510-($-$$) db 0
                 db 0x55,0xaa

