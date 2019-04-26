.include "include/registers.s"

.global segment_initialize
.global segment_refresh
.global segment_set
.global segment_dot

.section .data.semgent

current: .space 1
digits: .space 4

.section .text.segment

patterns:
	.byte 0xc0
	.byte 0xf9
	.byte 0xa4
	.byte 0xb0
	.byte 0x99
	.byte 0x92
	.byte 0x82
	.byte 0xf8
	.byte 0x80
	.byte 0x90
    .byte 0xFF
    .align 2

anodes:
    .byte 0x07
    .byte 0x0B
    .byte 0x0D
    .byte 0x0E
    .align 2

segment_initialize:
    ldi r16, 0x00
    sts current, r16
    sts digits+0, r16
    sts digits+1, r16
    sts digits+2, r16
    sts digits+3, r16
    load8 DDRSegments, 0xFF
    in r16, DDRAnodes
    ldi r17, 0x0F
    or r16, r17
    out DDRAnodes, r16
    ret

segment_refresh:
    lds r16, current
    loadY digits
    add YL, r16
    ld r17, Y
    loadZ anodes
    add ZL, r16
    lpm r18, Z
    ldi r20, 0xF0
    in r19, PORTAnodes
    and r19, r20
    or r18, r19
    out PORTSegments, r17
    out PORTAnodes, r18
    inc r16
    cpi r16, 4
    brne segment_refresh_store
    ldi r16, 0
segment_refresh_store:
    sts current, r16
    ret

segment_set:
    loadY digits
    add YL, r16
    loadZ patterns
    add ZL, r17
    lpm r18, Z
    st Y, r18
    ret

segment_dot:
    loadY digits
    add YL, r16
    ld r17, Y
    ldi r18, 0x7F
    and r17, r18
    st Y, r17
    ret
