        ;1. 主要功能
        ;   在屏幕上显示`Label Offset: "标号number的地址"`
        ;2. 实现该功能的主要过程
        ;   ① 直接向显存区写入`Label Offset:`，并设置字符的属性。
        ;   ② 使用寄存器存储标号number的地址。
        ;   ③ 使用循环与运算指令将number的地址分解为各个数字，并存储到数据段中。
        ;   ④ 最后将分解好的数位，使用循环写入显存区，并设置字符的属性。
         mov ax, 0xb800
         mov es, ax
         
         mov ax, 0x7c0
         mov ds, ax

         mov bx, msg
         mov si, 0
         mov di, 0
         mov cx, 28
  letter:
         mov ax, [bx+si]
         mov [es:di], ax
         inc si
         inc di
         loop letter

         mov ax, number
         mov di, 4
         mov bx, 10
         mov cx, 5
  digit:
         xor dx, dx
         div bx
         mov [number+di], dl
         dec di
         loop digit
   
         mov bx, number
         mov si, 0
         mov di, 0
         mov cx, 5
   show:
         mov ax, [bx+si]
         add ax, 0x30
         mov [es:28+di], ax
         mov byte [es:28+di+1], 0x07
         inc si
         add di, 2
         loop show


         jmp near $

  msg    db 'L', 0x07, 'a', 0x07, 'b', 0x07, 'e', 0x07, 'l', 0x07, ' ', 0x07, \
            'o', 0x07, 'f', 0x07, 'f', 0x07, 's', 0x07, 'e', 0x07, 't', 0x07, \
            ':', 0x07, ' ', 0x07
  number db 0, 0, 0, 0, 0

  times 510-($-$$) db 0
                   db 0x55, 0xaa
