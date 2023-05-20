@WCName
.string "TETRIS"
@WinName
.string "Tetris"

@buf_display
push %rax
push %rcx
push %rdx
push %rsi
push %rdi
push %r8
push %r9
push %r10
push %r11

sub $8,%rsp
mov $@_$DATA+576,%r8
mov $983488,%edx
mov @_$DATA+16,%rcx
push %r8
push %rdx
push %rcx
.dllcall "gdi32.dll" "SetBitmapBits"
add $24,%rsp
mov @_$DATA+0,%rcx
xor %edx,%edx
mov %rdx,%r8
mov $508,%r9
pushq $0xcc0020
push %rdx
push %rdx
pushq @_$DATA+8
pushq $484
push %r9
push %r8
push %rdx
push %rcx
.dllcall "gdi32.dll" "BitBlt"
add $80,%rsp

pop %r11
pop %r10
pop %r9
pop %r8
pop %rdi
pop %rsi
pop %rdx
pop %rcx
pop %rax
ret

@rect
push %rax
push %rcx
push %rdx
push %rsi
push %rdi
push %r8
push %r9

mov %eax,%r8d
mov %edx,%r9d
mov $2032,%eax
mul %ecx
lea @_$DATA+576-4(%rax,%r8,4),%rcx
@rect_X1
mov %esi,%r8d
@rect_X2
mov %r9d,(%rcx,%r8,4)
dec %r8d
jne @rect_X2
add $2032,%rcx
dec %edi
jne @rect_X1

pop %r9
pop %r8
pop %rdi
pop %rsi
pop %rdx
pop %rcx
pop %rax
ret
.align 2
@digits_bitmap
.word 075557
.word 044444
.word 071747
.word 074747
.word 044755
.word 074717
.word 075717
.word 044447
.word 075757
.word 074757
@N_bitmap
.byte 021
.byte 023
.byte 025
.byte 031
.byte 021
@E_bitmap
.byte 037
.byte 001
.byte 037
.byte 001
.byte 037
@X_bitmap
.byte 021
.byte 012
.byte 004
.byte 012
.byte 021
@T_bitmap
.byte 037
.byte 004
.byte 004
.byte 004
.byte 004
@S_bitmap
.byte 036
.byte 001
.byte 016
.byte 020
.byte 017
@C_bitmap
.byte 036
.byte 001
.byte 001
.byte 001
.byte 036
@O_bitmap
.byte 016
.byte 021
.byte 021
.byte 021
.byte 016
@R_bitmap
.byte 017
.byte 021
.byte 017
.byte 005
.byte 031
@NEXT_str
.byte 0,5,10,15
@SCORE_str
.byte 20,25,30,35,5
@Tetris_bitmap
.word 0x0660
.word 0x0660
.word 0x0660
.word 0x0660

.word 0x0072
.word 0x0262
.word 0x0270
.word 0x0232

.word 0x00f0
.word 0x2222
.word 0x00f0
.word 0x2222

.word 0x0074
.word 0x0622
.word 0x0170
.word 0x0223

.word 0x0063
.word 0x0264
.word 0x0063
.word 0x0264

.word 0x0071
.word 0x0226
.word 0x0470
.word 0x0322

.word 0x0036
.word 0x0231
.word 0x0036
.word 0x0231

@Tetris_color
.long 0x00ff00,0xffff00,0xff00ff,0xff0000,0x00ffff,0xff0000,0x00ffff

@p_digit
push %rax
push %rcx
push %rdx
push %rsi
push %rdi
shl $1,%edx
mov @digits_bitmap(%rdx),%si
mov $5,%dh
@p_digit_X1
mov $3,%dl
@p_digit_X2
test $1,%esi
je @p_digit_X3
push %rdx
push %rsi
mov $0xffffff,%edx
mov $4,%edi
mov %edi,%esi
call @rect

pop %rsi
pop %rdx
@p_digit_X3
add $4,%eax
shr $1,%esi
dec %dl
jne @p_digit_X2
sub $12,%eax
add $4,%ecx
dec %dh
jne @p_digit_X1

pop %rdi
pop %rsi
pop %rdx
pop %rcx
pop %rax
ret

@p_letter
push %rax
push %rcx
push %rdx
push %rsi
push %rdi

mov %rdx,%rsi
mov $5,%dh
@p_letter_X1
mov $5,%dl
mov (%rsi),%dil
@p_letter_X2
test $1,%edi
je @p_letter_X3
push %rdx
push %rsi
push %rdi
mov $0xffffff,%edx
mov $4,%edi
mov %edi,%esi
call @rect
pop %rdi
pop %rsi
pop %rdx
@p_letter_X3
shr $1,%edi
add $4,%eax
dec %dl
jne @p_letter_X2
inc %rsi
sub $20,%eax
add $4,%ecx
dec %dh
jne @p_letter_X1
pop %rdi
pop %rsi
pop %rdx
pop %rcx
pop %rax
ret

@p_block
push %rax
push %rcx
push %rdx
push %rsi
push %rdi

cmp $21,%eax
jae @p_block_end
cmp $20,%ecx
jae @p_block_end
shl $3,%eax
shl $3,%ecx
lea 4(%rax,%rax,2),%eax
lea 4(%rcx,%rcx,2),%ecx

mov $20,%esi
mov %esi,%edi
call @rect

@p_block_end

pop %rdi
pop %rsi
pop %rdx
pop %rcx
pop %rax
ret

@p_tetris
push %rax
push %rcx
push %rdx
push %rsi
push %rbx

mov %edx,%esi
and $0xfc,%dl
mov @Tetris_color(%rdx),%edx
shl $1,%esi
mov @Tetris_bitmap(%rsi),%si

mov $4,%bh
@p_tetris_X1
mov $4,%bl
@p_tetris_X2
test $1,%esi
je @p_tetris_X3
call @p_block
@p_tetris_X3
shr $1,%esi
inc %eax
dec %bl
jne @p_tetris_X2
sub $4,%eax
inc %ecx
dec %bh
jne @p_tetris_X1

pop %rbx
pop %rsi
pop %rdx
pop %rcx
pop %rax
ret

@p_map
push %rax
push %rcx
push %rdx
push %rsi

mov $@_$DATA+256,%rsi

xor %ecx,%ecx
@p_map_X1
xor %eax,%eax
@p_map_X2

mov (%rsi),%dl
test %dl,%dl
je @p_map_X3
movzbl %dl,%edx
shl $2,%edx
mov @Tetris_color-4(%rdx),%edx
call @p_block
@p_map_X3

inc %rsi

inc %eax
cmp $16,%eax
jne @p_map_X2
inc %ecx
cmp $20,%ecx
jne @p_map_X1

pop %rsi
pop %rdx
pop %rcx
pop %rax
ret

@paint_all
push %rbx
mov $388,%eax
xor %ecx,%ecx
mov $1,%esi
mov $484,%edi
mov $0xffffff,%edx
call @rect
mov $390+72,%eax
mov $2,%ecx
mov $4,%ebx
@paint_all_NEXT
movzbl @NEXT_str-1(%rbx),%edx
add $@N_bitmap,%edx
call @p_letter
sub $24,%eax
dec %ebx
jne @paint_all_NEXT

mov $390+96,%eax
mov $200,%ecx
mov $5,%ebx
@paint_all_SCORE
movzbl @SCORE_str-1(%rbx),%edx
add $@N_bitmap,%edx
call @p_letter
sub $24,%eax
dec %ebx
jne @paint_all_SCORE

call @p_map
mov @_$DATA+36,%edx
mov $17,%eax
mov $2,%ecx
call @p_tetris
mov @_$DATA+32,%edx
mov @_$DATA+40,%eax
mov @_$DATA+44,%ecx
call @p_tetris
mov @_$DATA+52,%eax
mov $490,%ebx
@p_score_X1
xor %edx,%edx
mov $10,%ecx
div %ecx
xchg %eax,%ebx
mov $226,%ecx
call @p_digit
sub $16,%eax
xchg %eax,%ebx
test %eax,%eax
jne @p_score_X1

pop %rbx
ret
@Tetris_rand
push %rcx
push %rdx
push %rsi
push %rdi
push %r8
push %r9
push %r10
push %r11
push %rbp
mov %rsp,%rbp
and $0xf0,%spl
sub $32,%rsp
.dllcall "msvcrt.dll" "rand"
xchg %al,%ah
xor $0x3456,%ax
mov $28,%ecx
xor %edx,%edx
div %ecx
mov %edx,%eax
mov %rbp,%rsp
pop %rbp
pop %r11
pop %r10
pop %r9
pop %r8
pop %rdi
pop %rsi
pop %rdx
pop %rcx
ret
@Tetris_clock
push %rcx
push %rdx
push %rsi
push %rdi
push %r8
push %r9
push %r10
push %r11
push %rbp
mov %rsp,%rbp
and $0xf0,%spl
sub $32,%rsp
.dllcall "msvcrt.dll" "clock"
mov %eax,%ecx
sub @_$DATA+60,%eax
mov %ecx,@_$DATA+60
mov %rbp,%rsp
pop %rbp
pop %r11
pop %r10
pop %r9
pop %r8
pop %rdi
pop %rsi
pop %rdx
pop %rcx
ret

@Tetris_check
push %rcx
push %rdx
push %rbx
push %rsi
mov @_$DATA+40,%eax
mov @_$DATA+44,%ecx
mov @_$DATA+32,%edx
shl $1,%edx
mov @Tetris_bitmap(%rdx),%dx
mov $4,%bh
@Tetris_check_X1
mov $4,%bl
@Tetris_check_X2

test $1,%edx
je @Tetris_check_X3
cmp $16,%eax
jae @Tetris_check_fail
mov %ecx,%esi
cmp $0,%esi
jl @Tetris_check_X3
cmp $20,%esi
jae @Tetris_check_fail
mov %ecx,%esi
shl $4,%esi
add %eax,%esi
cmpb $0,@_$DATA+256(%rsi)
jne @Tetris_check_fail

@Tetris_check_X3
shr $1,%edx
inc %eax
dec %bl
jne @Tetris_check_X2
sub $4,%eax
inc %ecx
dec %bh
jne @Tetris_check_X1


@Tetris_check_success
xor %eax,%eax
jmp @Tetris_check_end
@Tetris_check_fail
mov $1,%eax
@Tetris_check_end
pop %rsi
pop %rbx
pop %rdx
pop %rcx
ret

@game_over_msg
.string "Game Over"

@Tetris_game_over
movb $1,@_$DATA+48
xor %ecx,%ecx
mov %ecx,%r9d
mov $@game_over_msg,%rdx
mov %rdx,%r8
and $0xf0,%spl
push %r9
push %r8
push %rdx
push %rcx
.dllcall "user32.dll" "MessageBoxA"
xor %ecx,%ecx
mov %rcx,(%rsp)
.dllcall "kernel32.dll" "ExitProcess"


@Tetris_put
push %rax
push %rcx
push %rdx
push %rbx
push %rsi
push %rdi

mov @_$DATA+40,%eax
mov @_$DATA+44,%ecx
mov @_$DATA+32,%edx

mov %edx,%esi
shr $2,%esi
inc %esi
shl $1,%edx
mov @Tetris_bitmap(%rdx),%dx
mov $4,%bh
@Tetris_put_X1
mov $4,%bl
@Tetris_put_X2

test $1,%edx
je @Tetris_put_X3
cmp $0,%ecx
jl @Tetris_game_over
incb @_$DATA+129(%rcx)
mov %ecx,%edi
shl $4,%edi
add %eax,%edi
mov %sil,@_$DATA+256(%rdi)
@Tetris_put_X3
shr $1,%edx
inc %eax
dec %bl
jne @Tetris_put_X2
sub $4,%eax
inc %ecx
dec %bh
jne @Tetris_put_X1


xor %ecx,%ecx
mov %ecx,%eax
@Tetris_put_X4
cmpb $16,@_$DATA+129(%rcx)
jne @Tetris_put_X5
mov %ecx,%edx
@Tetris_put_X6
mov @_$DATA+129-1(%rdx),%bl
mov %bl,@_$DATA+129(%rdx)
dec %edx
jne @Tetris_put_X6
mov %eax,%edx
@Tetris_put_X7
mov @_$DATA+240(%rdx),%rbx
mov %rbx,@_$DATA+256(%rdx)
mov @_$DATA+240+8(%rdx),%rbx
mov %rbx,@_$DATA+256+8(%rdx)
sub $16,%edx
jne @Tetris_put_X7
incl @_$DATA+52
mov @_$DATA+56,%edx
sub $400,%edx
mov %edx,%ebx
shl $7,%edx
sub %ebx,%edx
shr $7,%edx
add $400,%edx
mov %edx,@_$DATA+56

@Tetris_put_X5
add $16,%eax
inc %ecx
cmp $20,%ecx
jne @Tetris_put_X4

mov @_$DATA+36,%eax
mov %eax,@_$DATA+32
call @Tetris_rand
mov %eax,@_$DATA+36
movl $6,@_$DATA+40
movl $-4,@_$DATA+44

pop %rdi
pop %rsi
pop %rbx
pop %rdx
pop %rcx
pop %rax
ret

@Tetris_rotate
push %rax
push %rcx
testb $1,@_$DATA+48
jne @Tetris_rotate_X1

mov @_$DATA+32,%eax
lea 1(%rax),%ecx
mov %al,%ch
and $3,%cl
and $0xfc,%al
or %cl,%al
mov %eax,@_$DATA+32

call @Tetris_check
test %al,%al
je @Tetris_rotate_X1

mov %ch,@_$DATA+32

@Tetris_rotate_X1

movb $1,@_$DATA+24
pop %rcx
pop %rax
ret

@Tetris_move
push %rax
push %rdx
testb $1,@_$DATA+48
jne @Tetris_move_end

add %eax,@_$DATA+40
add %ecx,@_$DATA+44
mov %eax,%edx
call @Tetris_check
xchg %eax,%edx
test %dl,%dl
je @Tetris_move_X1
sub %eax,@_$DATA+40
sub %ecx,@_$DATA+44
@Tetris_move_X1
test %dl,%cl
je @Tetris_move_end

call @Tetris_put

@Tetris_move_end
movb $1,@_$DATA+24
pop %rdx
pop %rax
ret

@game_init
xor %ecx,%ecx
sub $32,%rsp
push %rcx
.dllcall "msvcrt.dll" "time"
mov %rax,%rcx
mov %rax,(%rsp)
.dllcall "msvcrt.dll" "srand"
add $40,%rsp
call @Tetris_rand
mov %eax,@_$DATA+32
call @Tetris_rand
mov %eax,@_$DATA+36
movl $6,@_$DATA+40
movl $-4,@_$DATA+44
movl $1000,@_$DATA+56
ret

@T_game
sub $8,%rsp
call @Tetris_clock
@T_game_loop

mov $0,%al
xchg %al,@_$DATA+68
cmp $1,%al
jne @T_game_Up

call @Tetris_rotate
jmp @T_game_E1

@T_game_Up
cmp $2,%al
jne @T_game_Down
xor %eax,%eax
mov $1,%ecx
call @Tetris_move
jmp @T_game_E1

@T_game_Down
cmp $3,%al
jne @T_game_Left
xor %ecx,%ecx
mov $-1,%eax
call @Tetris_move
jmp @T_game_E1

@T_game_Left
cmp $4,%al
jne @T_game_E1
xor %ecx,%ecx
mov $1,%eax
call @Tetris_move
@T_game_E1

cmpb $0,@_$DATA+24
je @T_game_paint
movb $0,@_$DATA+24
mov $983488,%r8
xor %edx,%edx
mov $@_$DATA+576,%ecx
push %r8
push %r8
push %rdx
push %rcx
.dllcall "msvcrt.dll" "memset"
add $32,%rsp
call @paint_all
call @buf_display
@T_game_paint

sub $24,%rsp
mov $3,%ecx
push %rcx
.dllcall "kernel32.dll" "Sleep"
add $32,%rsp
call @Tetris_clock
shl $1,%eax
add @_$DATA+64,%eax
cmp @_$DATA+56,%eax
jb @T_game_X1
sub @_$DATA+56,%eax
push %rax
xor %eax,%eax
mov $1,%ecx
call @Tetris_move
pop %rax
@T_game_X1
mov %eax,@_$DATA+64
jmp @T_game_loop




@WndProc
push %rbp
mov %rsp,%rbp
push %r9
push %r8
push %rdx
push %rcx
cmp $2,%edx
jne @WndProc_Destroy
xor %ecx,%ecx
sub $24,%rsp
push %rcx
.dllcall "kernel32.dll" "ExitProcess"

@WndProc_Destroy
cmp $15,%edx
jne @WndProc_Paint
sub $96,%rsp
mov -32(%rbp),%rcx
lea 16(%rsp),%rdx
push %rdx
push %rcx
.dllcall "user32.dll" "BeginPaint"
add $16,%rsp
mov -32(%rbp),%rcx
lea 16(%rsp),%rdx
push %rdx
push %rcx
.dllcall "user32.dll" "EndPaint"
add $112,%rsp
movb $1,@_$DATA+24
jmp @WndProc_End
@WndProc_Paint
cmp $256,%edx
jne @WndProc_Keydown
cmp $38,%r8d
jne @Keydown_Up

movb $1,@_$DATA+68

jmp @WndProc_End
@Keydown_Up
cmp $40,%r8d
jne @Keydown_Down

movb $2,@_$DATA+68

jmp @WndProc_End
@Keydown_Down
cmp $37,%r8d
jne @Keydown_Left

movb $3,@_$DATA+68

jmp @WndProc_End
@Keydown_Left
cmp $39,%r8d
jne @Keydown_Right

movb $4,@_$DATA+68
@Keydown_Right
@WndProc_Keydown

@WndProc_End
lea -32(%rbp),%rsp
mov (%rsp),%rcx
mov 8(%rsp),%rdx
mov 16(%rsp),%r8
mov 24(%rsp),%r9
.dllcall "user32.dll" "DefWindowProcA"
add $32,%rsp
pop %rbp
ret

.entry
push %rbp
mov %rsp,%rbp
sub $80,%rsp

call @game_init

xor %ebx,%ebx

movq $80,(%rsp)
movq $@WndProc,8(%rsp)
mov %rbx,16(%rsp)
movq $0x400000,24(%rsp)

sub $16,%rsp

mov $0x7f00,%edx
mov %ebx,%ecx
push %rdx
push %rcx
.dllcall "user32.dll" "LoadIconA"
add $16,%rsp
mov %rax,48(%rsp)

mov $0x7f00,%edx
mov %ebx,%ecx
push %rdx
push %rcx
.dllcall "user32.dll" "LoadCursorA"
add $32,%rsp
mov %rax,40(%rsp)
movq $8,48(%rsp)
mov %rbx,56(%rsp)
movq $@WCName,64(%rsp)
mov %rbx,72(%rsp)

mov %rsp,%rcx
sub $24,%rsp
push %rcx
.dllcall "user32.dll" "RegisterClassExA"
add $32,%rsp
test %rax,%rax
je @Err_Exit

push %rbx
pushq $0x400000
push %rbx
push %rbx
pushq $484+29
pushq $388+120+6
push %rbx
push %rbx
mov $0x10c80000,%r9d
mov $@WinName,%r8d
mov $@WCName,%edx
mov $0x100,%ecx
push %r9
push %r8
push %rdx
push %rcx
.dllcall "user32.dll" "CreateWindowExA"
add $72,%rsp
test %rax,%rax
je @Err_Exit

mov %rax,%r14
mov %rax,%rcx

push %rcx
.dllcall "user32.dll" "GetDC"
add $8,%rsp
mov %rax,%rcx
mov %rax,@_$DATA+0
push %rcx
.dllcall "gdi32.dll" "CreateCompatibleDC"
mov %rax,@_$DATA+8
mov @_$DATA+0,%rcx
mov $388+120,%edx
mov $484,%r8d
push %r8
push %rdx
push %rcx
.dllcall "gdi32.dll" "CreateCompatibleBitmap"
add $16,%rsp
mov %rax,@_$DATA+16
mov %rax,%rdx
mov @_$DATA+8,%rcx
push %rdx
push %rcx
.dllcall "gdi32.dll" "SelectObject"
add $56,%rsp

push %rbx
push %rbx
mov %rbx,%r9
mov $@T_game,%r8
mov %ebx,%edx
mov %ebx,%ecx
push %r9
push %r8
push %rdx
push %rcx
.dllcall "kernel32.dll" "CreateThread"
add $48,%rsp

@MsgLoop
mov %rbx,%r9
mov %rbx,%r8
mov %ebx,%edx
mov %rsp,%rcx
push %r9
push %r8
push %rdx
push %rcx
.dllcall "user32.dll" "GetMessageA"
add $8,%rsp
cmp $0,%rax
jl @Err_Exit
lea 24(%rsp),%rcx
push %rcx
.dllcall "user32.dll" "TranslateMessage"
add $8,%rsp
lea 24(%rsp),%rcx
push %rcx
.dllcall "user32.dll" "DispatchMessageA"
add $32,%rsp

jmp @MsgLoop

@Err_Exit
mov %rbp,%rsp
pop %rbp
ret

.datasize 995328