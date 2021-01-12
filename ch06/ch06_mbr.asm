         jmp near start                ;让IP跳转到start标号所指的地址
         
  mytext db 'L',0x07,'a',0x07,'b',0x07,'e',0x07,'l',0x07,' ',0x07,'o',0x07,\
            'f',0x07,'f',0x07,'s',0x07,'e',0x07,'t',0x07,':',0x07
  number db 0,0,0,0,0
  
  start:
         mov ax,0x7c0                  ;设置数据段基地址 
         mov ds,ax
         
         mov ax,0xb800                 ;设置附加段基地址 
         mov es,ax
         
         cld                           ;方向标志清零指令(无操作数指令),将DF标志清零,指示传送是正方向的
                                       ;与之相反的指令是std
         mov si,mytext                 ;把mytext的地址赋给si,后面配合ds使用
         mov di,0                      ;将di置0,后面配合es使用
         mov cx,(number-mytext)/2      ;实际上等于 13
         rep movsw                     ;rep(repeat)重复后面的指令直到cx为0,段地址和偏移地址分别由DI,SI指定
     
         ;得到标号所代表的偏移地址
         mov ax,number                 ;用作被除数的低16位
         
         ;计算各个数位
         mov bx,number                 ;配合[bx]即[ds:bx]来按低端字节序保存各个数位
         mov cx,5                      ;循环次数 
         mov si,10                     ;用作除数 
  digit: 
         xor dx,dx                     ;dx清零
         div si                        ;32位被除数16位除数的除法,(dx ax)/si=ax...dx,dx是被除数的高位,所以每次都要把dx置零
         mov [bx],dl                   ;商保存在dx中,因为si是10,使用8字节存储,所以余数就是dl,[bx]即[ds:bx]
         inc bx                        ;递增偏移量
         loop digit
         
         ;显示各个数位
         mov bx,number 
         mov si,4                      ;[bx+si]指向number区域的第5个字节,show段要逆序打印
   show:
         mov al,[bx+si]
         add al,0x30                   ;加上0x30得到ASCII码
         mov ah,0x04                   ;设置字符显示属性
         mov [es:di],ax                ;将字符送到显存区
         add di,2                      ;将di指向显存区下一个单元
         dec si
         jns show                      ;如果未设置符号位SF,则转移到标号show所在位置执行
                                       ;计算结果最高比特位为0,SF为0,反之为1
         
         mov word [es:di],0x0744

         jmp near $

  times 510-($-$$) db 0
                   db 0x55,0xaa