         jmp near start
	
 message db '1+2+3+...+100='    ;直接声明一个字符串
        
 start:
         mov ax,0x7c0           ;设置数据段的段基地址 
         mov ds,ax

         mov ax,0xb800          ;设置附加段基址到显示缓冲区
         mov es,ax

         ;以下显示字符串 
         mov si,message          
         mov di,0
         mov cx,start-message   ;标号的地址相减得到字符串的字节数
     @g:
         mov al,[si]            ;[si]==[ds:si]
         mov [es:di],al
         inc di                 ;增加偏移量,指向显存区下一个字节
         mov byte [es:di],0x07  ;设置字符属性
         inc di
         inc si
         loop @g

         ;以下计算1到100的和 
         xor ax,ax              ;清零
         mov cx,1
     @f:
         add ax,cx
         inc cx
         cmp cx,100             ;比较指令,会影响标志寄存器
         jle @f                 ;小于等于条件转移指令,通过标志寄存器来判断

         ;以下计算累加和的每个数位 
         xor cx,cx              ;设置堆栈段的段基地址
         mov ss,cx
         mov sp,cx

         mov bx,10              ;除数
         xor cx,cx              ;清零
     @d:
         inc cx
         xor dx,dx
         div bx                 ;32位除以16位的除法
         or dl,0x30             ;一个特例,dl的高4位为0,0x30的低四位为0,或的效果与加法相同,加上0x30,得到数字对应的ascii值,dl:0000 0000 ~ 0000 1001
         push dx
         cmp ax,0
         jne @d                 ;不等于条件转移指令

         ;以下显示各个数位 
     @a:
         pop dx
         mov [es:di],dl
         inc di
         mov byte [es:di],0x07
         inc di
         loop @a
       
         jmp near $             ;$是一个特殊的标号,代表当前行开头的地址
       

times 510-($-$$) db 0           ;$$也是一个特殊的标号,代表当前段开头的地址,这里通过计算,来对代码进行填充,
                 db 0x55,0xaa   ;使其恰好等于512字节,以放入ROM-BIOS区中,最后0x55,0xaa用来标记这是一个有效的引导程序