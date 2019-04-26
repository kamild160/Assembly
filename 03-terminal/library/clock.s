.include "include/registers.s"

.global clock_initialize
.global clock_refresh
.global clock_get

.section .data.clock

hour:
    .space 1
minute:
    .space 1
second:
    .space 1
timer:
    .space 2

.section .text.clock

clock_initialize:
    ldi r16, 22
    sts hour, r16
    ldi r16, 43
    sts minute, r16
    ldi r16, 0
    sts second, r16
    loadX 675
    sts timer, XL
    sts timer+1, XH
    ret

clock_dot_refresh:
    cpi XH, 0x01
    brne clock_dot_refresh_end
    cpi XL, 0x53
    brne clock_dot_refresh_end
    ldi r16, 2
    call segment_dot
clock_dot_refresh_end:
    ret

clock_mod10:
    ldi r17, 0
clock_mod10_loop:
    inc r17
    subi r16, 10
    brpl clock_mod10_loop
    dec r17
    subi r16, -10
    ret

clock_refresh:
    lds XL, timer
    lds XH, timer+1
    call clock_dot_refresh
    sbiw XL, 1
    cpi XH, 0xFF
    brne clock_refresh_end
    cpi XL, 0xFF
    brne clock_refresh_end
    lds r16, second
    lds r17, minute
    lds r18, hour
    inc r16
    cpi r16, 60
    brne clock_refresh_display
    ldi r16, 0
    inc r17
    cpi r17, 60
    brne clock_refresh_display
    ldi r17, 0
    inc r18
    cpi r18, 24
    brne clock_refresh_display
    ldi r18, 0
clock_refresh_display:
    sts second, r16
    sts minute, r17
    sts hour, r18
    mov r20, r18
    mov r16, r17
    call clock_mod10
    mov r19, r17
    mov r17, r16
    ldi r16, 0
    call segment_set
    ldi r16, 1
    mov r17, r19
    call segment_set
    mov r16, r20
    call clock_mod10
    mov r19, r17
    mov r17, r16
    ldi r16, 2
    call segment_set
    ldi r16, 3
    mov r17, r19
    call segment_set
    loadX 675
clock_refresh_end:
    sts timer, XL
    sts timer+1, XH
    ret

clock_get:
    lds r16, minute
    call clock_mod10
    mov r18, r16
    mov r19, r17
    lds r16, hour
    call clock_mod10
    ret
