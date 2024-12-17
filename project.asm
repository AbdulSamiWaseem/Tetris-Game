[org 0x0100]
jmp start
clockTXT: dw ':', 0
clockMinutes: dw 4
clockSeconds: dw 59
string: db 'Score: '
score: db 00
msg: db 'The End!!!'



Delay:
     push ax
     push bx
     push cx
     push dx
     push si
     push di
     push bp
     mov cx, 0xffff
     delaying:
      add ax, 1
      add bx, 1
      add dx, 1
      add si, 1
      add di, 1
      add bp, 1
     loop delaying
     pop bp
     pop di
     pop si
     pop dx
     pop cx 
     pop bx
     pop ax
     ret

printClockSTR:     
     push bp
     mov  bp, sp 
     push es 
     push ax 
     push cx 
     push si 
     push di 
     push ds  
     pop es                 ; load ds in es 
     mov di, [bp + 4]       ; point di to string 
     mov cx, 0xffff         ; load maximum number in cx 
     xor al, al             ; load a zero in al 
     repne scasb            ; find zero in the string 
     mov ax, 0xffff         ; load maximum number in ax 
     sub ax, cx             ; find change in cx 
     dec ax                 ; exclude null from length 
     jz strExit             ; no printing if string is empty
     mov cx, ax             ; load string length in cx 
     mov ax, 0xb800
     mov es, ax
     mov di, [bp+8]         ; point di to required location
     xor ax, ax 
     mov ah, [bp+6]          ; load attribute in ah
     mov si, [bp+4]          ; point si to string 
    cld                      ; auto increment mode 
     nextchar:     
         lodsb               ; load next char in al 
         stosw               ; print char/attribute pair 
         loop nextchar       ; repeat for the whole string 
     strExit:
         pop di 
         pop si 
         pop cx 
         pop ax 
         pop es 
         pop bp 
         ret 6
printNum:
   push bp 
   mov bp, sp 
   push es 
   push ax 
   push bx 
   push cx 
   push dx 
   push di
   mov ax, [bp+4]    ; load number in ax 
   mov bx, 10        ; use base 10 for division 
   mov cx, 0         ; initialize count of digits 
   nextdigit:
     mov dx, 0       ; zero upper half of dividend 
     div bx          ; divide by 10 
     add dl, 0x30    ; convert digit into ascii value 
     push dx         ; save ascii value on stack 
     inc cx          ; increment count of values 
     cmp ax, 0       ; is the quotient zero 
   jnz nextdigit     ; if no divide it again 
   nextpos:
     pop dx          ; remove a digit from the stack 
     mov dh, 0x70    ; use normal attribute 
     mov [es:di], dx ; print char on screen 
     add di, 2       ; move to next screen location 
     loop nextpos    ; repeat for all digits on stack
    pop di
    pop dx 
    pop cx 
    pop bx 
    pop ax 
    pop es 
    pop bp 
    ret 2 
clock:
push di
mov word[es:764], 0x0720
mov word[es:766], 0x0720
mov word[es:768], 0x0720
 mov di, 760
 push word [clockMinutes]
 call printNum
 mov di, 762
 push di
 push byte 0x70
 push word clockTXT
 call printClockSTR
 mov di, 764
 push word [clockSeconds]
 call printNum
 cmp word [clockSeconds], 0x0
 jle decMinute
 dec word [clockSeconds]
 pop di
 ret
 decMinute:
 cmp word [clockMinutes], 0x0
 je ending
 dec word [clockMinutes]
 mov word [clockSeconds], 59
 ending:
 pop di
 ret
 


print:
push bp
mov bp, sp
push ax
push bx
push cx
push dx
push si
push di

mov ax, 0xb800
mov es, ax
mov cx, 3
mov bx, [bp+4]
mov cx, [bp+6]
mov si, 0;
k:
mov al, [bx+si]
mov ah, 7
mov [es:di], ax
add di, 2
add si, 1
loop k

pop di
pop si
pop dx
pop cx
pop bx
pop ax
pop bp
ret 4

printnum:
push bp
mov bp, sp
push es
push ax
push bx
push cx
push dx
push di
mov ax, 0xb800
mov es, ax 
mov ax, [bp+4]
mov bx, 10 
mov cx, 0
nextDigit:
mov dx, 0 
div bx 
add dl, 0x30 
push dx 
inc cx 
cmp ax, 0 
jnz nextDigit 
mov di, 614 ; point di to top left column
nextPos:
pop dx ; remove a digit from the stack
mov dh, 0x07 ; use normal attribute
mov [es:di], dx ; print char on screen
add di, 2 ; move to next screen location
loop nextPos ; repeat for all digits on stack
pop di
pop dx
pop cx
pop bx
pop ax
pop es
pop bp
ret 2


clrscr:
push bp
mov bp, sp
push ax
push si
push di
mov ax, 0xb800
mov es, ax
mov di, 0
mov ax, 0x1020
mov cx, 2000
cld
rep stosw
mov ax, 0x077C
mov si, 0
mov cx, 25
l1:
mov [es:si], ax
add si, 30
mov [es:si], ax
add si, 2
mov [es:si], ax
add si, 68
mov [es:si], ax
add si, 2
mov [es:si], ax
add si, 56
mov [es:si], ax
add si, 2
loop l1
mov cx, 78
mov si, 2
mov ax, 0x072D
l2:
mov [es:si], ax
add si, 2
loop l2
mov cx, 78
mov si, 3842
l3:
mov [es:si], ax
add si, 2
loop l3

mov ah, 0x1F
mov si, string
mov cx, 7
mov di, 600

l4:
lodsb
stosw
loop l4

mov ax, 0xb800
mov es, ax
mov di, 614
mov ax, 0
mov al, [score]
push ax
call printnum

mov ax, 0xff20
mov cx, 3
mov di, 1566
l5:
mov [es:di], ax
add di, 2
loop l5

sub di, 164
mov [es:di], ax


pop di
pop si
pop ax
pop bp
ret

clrscr2:
push bp
mov bp, sp
push ax
push si

mov ax, 0xb800
mov es, ax
mov ax, 0x720
mov si, 0
mov cx, 2000
lwer:
mov [es:si], ax
add si, 2
loop lwer

mov di, 1500
mov bx, 10
push bx
mov bx, msg
push bx
call print

pop si
pop ax
pop bp
ret

s1:
push ax
push cx
;push di
push si

mov ax, 0xb800
mov es, ax
mov di, 614
mov ax, 0
mov al, [score]
push ax
call printnum

mov ax, 0x1020
mov di, 1406
mov dx, di
mov cx, 6
mov si, 6
jmp l51
l52:
add dx, 160
mov di, dx
mov cx, 6
l51:
mov [es:di], ax
add di, 2 
loop l51
dec si
cmp si, 0
jne l52

mov di, 1566
mov ax, 0xff20
mov cx, 3
l50:
mov [es:di], ax
add di, 2
loop l50
add di, 156
mov [es:di], ax

mov ax, 0xff20
mov cx, 3
mov di, 60
mov dx, 1
jmp l10
l12:
call delay
mov cx, 3
l13:
mov word[es:di], 0x1020
add di, 2
loop l13

sub di, 164
mov word[es:di], 0x1020

mov di, si
add di, 160
mov ax, 0xff20
mov cx, 3

in al, 0x60
cmp al, 0x4b
jne c4
call left
c4:
cmp al, 0x4d
jne l10
add di, 4
call right
sub di, 4

l10:
mov si, di
l11:
mov word[es:di], 0xff20
add di, 2
loop l11

sub di, 164
mov word[es:di], 0xff20
mov di, si

cmp di, 0
jl end11
cmp word[es:di+160], 0xff20
je end0
cmp word[es:di+162], 0xff20
je end0
cmp word[es:di+164], 0xff20
je end0
cmp di, 3700
jl l12


end0:
pop si
;pop di
pop cx
pop ax
ret

end11:
call clrscr2
mov ax, 0x4c00
int 21h

s2:
push ax
push cx
;push di
push si

mov ax, 0xb800
mov es, ax
mov di, 614
mov ax, 0
mov al, [score]
push ax
call printnum

mov ax, 0x1020
mov di, 1406
mov dx, di
mov cx, 6
mov si, 6
jmp l53
l54:
add dx, 160
mov di, dx
mov cx, 6
l53:
mov [es:di], ax
add di, 2 
loop l53
dec si
cmp si, 0
jne l54

mov ax, 0xff20
mov di, 1566
mov [es:di], ax
add di, 2
mov [es:di], ax
add di, 158
mov [es:di], ax
add di, 2
mov [es:di], ax

mov ax, 0xff20
mov cx, 3
mov di, 60
mov dx, 2
jmp l14

l16:
call delay
mov di, si
mov cx, 3
l17:
mov word[es:di], 0x1020
add di, 2
loop l17

add di, 156
mov word[es:di], 0x1020

mov di, si
add di, 160
mov cx, 3

in al, 0x60
cmp al, 0x4b
jne c3
call left
c3:
cmp al, 0x4d
jne l14
add di, 4
call right
sub di, 4

l14:
mov si, di
l15:
mov word[es:di], 0xff20
add di, 2
loop l15

add di, 156
mov word[es:di], 0xff20

cmp di, 0
jl end10
cmp word[es:di+160], 0xff20
je end1
mov di, si
cmp word[es:di+160], 0xff20
je end1
add di, 4
cmp word[es:di+160], 0xff20
je end1
add di, 158
cmp di, 3700
jl l16

end1:
pop si
;pop di
pop cx
pop ax
ret

end10:
call clrscr2
mov ax, 0x4c00
int 21h

s3:
push ax
push cx
;push di
push si

mov ax, 0xb800
mov es, ax
mov di, 614
mov ax, 0
mov al, [score]
push ax
call printnum

mov ax, 0x1020
mov di, 1406
mov dx, di
mov cx, 6
mov si, 6
jmp l55
l56:
add dx, 160
mov di, dx
mov cx, 6
l55:
mov [es:di], ax
add di, 2 
loop l55
dec si
cmp si, 0
jne l56

mov di, 1566
mov word[es:di], 0xff20
add di, 2
mov word[es:di], 0xff20
add di, 2
mov word[es:di], 0xff20
add di, 156
mov word[es:di], 0xff20
add di, 2
mov word[es:di], 0xff20
add di, 2
mov word[es:di], 0xff20

mov cx, 2
mov di, 60
mov dx, 3
jmp l18

l20:
call delay
mov di, si
mov cx, 2
l21:
mov word[es:di], 0x1020
add di, 2
loop l21

add di, 156
mov word[es:di], 0x1020
add di, 2
mov word[es:di], 0x1020

mov di, si
add di, 160
mov cx, 2

in al, 0x60
cmp al, 0x4b
jne c1
call left
c1:
cmp al, 0x4d
jne l18
add di, 2
call right
sub di, 2

l18:
mov si, di
l19:
mov word[es:di], 0xff20
add di, 2
loop l19

add di, 156
mov word[es:di], 0xff20
add di, 2
mov word[es:di], 0xff20

cmp di, 0
jl end9
cmp word[es:di+158], 0xff20
je end2
cmp word[es:di+160], 0xff20
je end2
cmp di, 3700
jl l20

end2:
pop si
;pop di
pop cx
pop ax
ret

end9:
call clrscr2
mov ax, 0x4c00
int 21h

s4:
push ax
push cx
;push di
push si

mov ax, 0xb800
mov es, ax
mov di, 614
mov ax, 0
mov al, [score]
push ax
call printnum

mov ax, 0x1020
mov di, 1406
mov dx, di
mov cx, 6
mov si, 6
jmp l57
l58:
add dx, 160
mov di, dx
mov cx, 6
l57:
mov [es:di], ax
add di, 2 
loop l57
dec si
cmp si, 0
jne l58

mov di, 1566
mov ax, 0xff20
mov [es:di], ax
add di, 160
mov [es:di], ax
add di, 160
mov [es:di], ax
add di, 160
mov [es:di], ax
add di, 160
mov [es:di], ax
add di, 160


mov cx, 3
mov di, 60
mov dx, 4
jmp l22

l24:
call delay
mov di, si
mov cx, 3
l25:
mov word[es:di], 0x1020
add di, 2
loop l25

add di, 154
mov word[es:di], 0x1020
add di, 2
mov word[es:di], 0x1020
add di, 2
mov word[es:di], 0x1020

mov di, si
add di, 160
mov cx, 3

in al, 0x60
cmp al, 0x4b
jne c0
call left
c0:
cmp al, 0x4d
jne l22
add di, 4
call right
sub di, 4

l22:
mov si, di
l23:
mov word[es:di], 0xff20
add di, 2
loop l23

add di, 154
mov word[es:di], 0xff20
add di, 2
mov word[es:di], 0xff20
add di, 2
mov word[es:di], 0xff20

cmp di, 0
jl end8
cmp word[es:di+158], 0xff20
je end3
cmp word[es:di+156], 0xff20
je end3
cmp word[es:di+160], 0xff20
je end3
cmp di, 3700
jl l24

end3:
pop si
;pop di
pop cx
pop ax
ret

end8:
call clrscr2
mov ax, 0x4c00
int 21h

s5:
push ax
push cx
;push di
push si

mov ax, 0xb800
mov es, ax
mov di, 614
mov ax, 0
mov al, [score]
push ax
call printnum

mov ax, 0x1020
mov di, 1406
mov dx, di
mov cx, 6
mov si, 6
jmp l59
l60:
add dx, 160
mov di, dx
mov cx, 6
l59:
mov [es:di], ax
add di, 2 
loop l59
dec si
cmp si, 0
jne l60

mov di, 1566
mov ax, 0xff20
mov [es:di], ax
add di, 2
mov [es:di], ax
add di, 2
mov [es:di], ax
add di, 2
mov [es:di], ax
add di, 2
mov [es:di], ax
add di, 2

mov bx, 0
mov cx, 5
mov di, 60
mov si, di
mov dx, 5
jmp l26
l27:
call delay
mov di, si
mov cx, 5
l28:
mov word[es:di], 0x1020
add di, 160
loop l28
mov cx, 5
mov di, si
add di, 160
mov si, di
in al, 0x60
cmp al, 0x4b
jne re2
call left
re2:
cmp al, 0x4d
jne lr
call right
lr:
mov ax, 0
add ax, 0
mov si, di
l26:
mov word[es:di], 0xff20
add di, 160
loop l26

cmp di, 0
jl end7
cmp word[es:di], 0xff20
je end4
cmp di, 3800
jl l27

end4:
pop si
;pop di
pop cx
pop ax
ret

end7:
call clrscr2
mov ax, 0x4c00
int 21h


s6:
push ax
push cx
;push di
push si

mov ax, 0xb800
mov es, ax
mov di, 614
mov ax, 0
mov al, [score]
push ax
call printnum

mov ax, 0x1020
mov di, 1406
mov dx, di
mov cx, 6
mov si, 6
jmp l61
l62:
add dx, 160
mov di, dx
mov cx, 6
l61:
mov [es:di], ax
add di, 2 
loop l61
dec si
cmp si, 0
jne l62

mov cx, 5
mov di, 60
mov dx, 6
jmp re6
l30:
call delay
mov cx, 5
l31:
mov word[es:di], 0x1020
add di, 2
loop l31
mov cx, 5
mov di, si
add di, 160

in al, 0x60
cmp al, 0x4b
jne re5
call left
re5:
cmp al, 0x4d
jne re6
add di, 8
call right
sub di, 8
re6:
mov si, di
l29:
mov word[es:di], 0xff20
add di, 2
loop l29
mov di, si

cmp di, 0
jl end6
cmp word[es:di+160], 0xff20
je end5
cmp word[es:di+162], 0xff20
je end5
cmp word[es:di+164], 0xff20
je end5
cmp word[es:di+166], 0xff20
je end5
cmp word[es:di+168], 0xff20
je end5
cmp di, 3700
jl l30

end5:
pop si
;pop di
pop cx
pop ax
ret

end6:
call clrscr2
mov ax, 0x4c00
int 21h

left:
cmp word[es:di-2], 0x077c
je le1
cmp word[es:di-2], 0xff20
je le1
cmp word[es:di-162], 0xff20
je le1
sub di, 2
le1:
ret

right:
cmp word[es:di+2], 0x077c
je re1
cmp word[es:di+2], 0xff20
je re1
cmp word[es:di+162], 0xff20
je re1
add di, 2
re1:
ret

delay:
push cx
mov cx, 0xffff
lo:
dec cx
jnz lo
mov cx, 0xffff
li:
dec cx
jnz li
mov cx, 0xffff
lu:
dec cx
jnz lu
pop cx
ret

scrolldown:
push ax
push bx
push cx
push dx
push si
push di
push ds

b:
mov dx, 23
mov cx, 34
mov di, 34
mov ax, 0xff20
a1:
add di, 160
push di
cld
repe scasw
pop di
cmp cx, 0
je scroll
mov cx, 34
dec dx
cmp dx, 0
jne a1
jmp a2

scroll:
mov ax, 24
sub ax, dx
mov cx, ax
sub cx, 1
mov dx, cx
mov bx, cx
mov cx, 33

mov si, di
sub si, 160
push es
pop ds
cld
sc2:
push si
rep movsw
pop di
sub si, 66
sub si, 160
mov cx, 33
dec dx
cmp dx, 0
jne sc2

mov ax, 0x1020
mov cx, 33
cld
sc3:
rep stosw
sub di, 66
sub di, 160
mov cx, 33
dec bx
cmp bx, 0
jne sc3

mov bl, [score]
add bl, 10
mov [score], bl
jmp b

a2:
pop ds
pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret

start:
call clrscr

ap:
mov di, 760
 call clock

call s1
call scrolldown
mov di, 760
 call clock

call s2
call scrolldown
mov di, 760
 call clock

call s3
call scrolldown
mov di, 760
 call clock

call s4
call scrolldown
mov di, 760
 call clock

call s5
call scrolldown
mov di, 760
 call clock

call s6
call scrolldown
cmp di, 60
jle e1
 
jmp ap


e1:
cmp word[es:di+160], 0xff20
je e2
cmp word[es:di+162], 0xff20
je e2
cmp word[es:di+158], 0xff20
je e2
jmp ap
e2:
call clrscr2
mov ax, 0x4c00
int 21h