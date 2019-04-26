.include "include/registers.s"

.global system_initialize
.global system_refresh
.global system_debounce
.global system_copy_string

.equ debounce_cycles, 255

.section .data.uart

debouncing:
    .space 1

.section .text.system

system_initialize:
    load8 TCCR0, 0x03
    load8 TCNT0, 0x00
    load8 TIMSK, 0x01
    sbi PORTD, 2
    sbi PORTD, 3
	load8 GICR, 0xC0
	load8 MCUCR, 0x0A
    ldi r16, 0
    sts debouncing, r16
    sei
    ret

system_refresh:
    lds r16, debouncing
    cpi r16, 0
    breq system_refresh_end
    sbis PIND, 2
    rjmp system_refresh_restart
    sbis PIND, 3
    rjmp system_refresh_restart
    dec r16
    sts debouncing, r16
    cpi r16, 0
    brne system_refresh_end
    load8 GICR, 0xC0
    rjmp system_refresh_end
system_refresh_restart:
    ldi r16, debounce_cycles
    sts debouncing, r16
system_refresh_end:
    ret

system_debounce:
    load8 GICR, 0x00
    load8 GIFR, 0xC0
    ldi r16, debounce_cycles
    sts debouncing, r16
    ret

system_copy_string:
    lpm r17, Z+
    st Y+, r17
    cpi r17, 0
    brne system_copy_string
    ret
