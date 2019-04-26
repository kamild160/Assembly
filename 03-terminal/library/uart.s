.include "include/registers.s"

.global uart_initialize
.global uart_refresh
.global uart_send
.global uart_echo
.global uart_load

.equ buffer_size, 128

.section .data.uart

output_top:
    .space 1
output_pointer:
    .space 1
output_buffer:
    .space buffer_size
character_buffer: ;2 bajty, inicjalizujemy 0 
    .space 2
input_top:
    .space 1
input_pointer:
    .space 1
input_buffer:
    .space buffer_size

.section .text.uart

uart_initialize:
    load8 UCSRA, 0x00
    load8 UCSRB, 0xD8
    load8 UCSRC, 0x86
    load8 UBRRL, 5
    ldi r16, 0x00
    sts output_pointer, r16
    sts output_top, r16
    sts input_top, r16
    sts input_pointer, r16
    sts character_buffer, r16
    sts character_buffer+1, r16
    ret

uart_echo: ;czyta znak który przyszedł po uarcie, chowa w buforze znaki 
    in r16, UDR ;zczytujemy znak z rejestru 
    lds r17, input_top
    ldi r18, 0
    loadY input_buffer
    add YL, r17
    adc YH, r18
    st Y, r16
    inc r17
    cpi r17, buffer_size
    brne uart_echo_not_overflow
    ldi r17, 0
uart_echo_not_overflow:
    sts input_top, r17
    sts character_buffer, r16 ;2 znakowy nufor 
    loadZ character_buffer
    call uart_send
    lds r16, character_buffer
    ret

uart_load:
    lds r16, input_pointer ;ostatni znak bufora
    lds r17, input_top 
    ldi r18, 0 
    loadY input_buffer
    add YL, r16
    adc YH, r18
uart_load_loop: ;zwiększamy aż do inputtop
    ld r19, Y+
    st Z+, r19
    inc r16
    cpi r16, buffer_size
    brne uart_load_not_overflow
    ldi r16, 0
    loadY input_buffer
uart_load_not_overflow:
    cp r16, r17 
    brne uart_load_loop
    sts input_pointer, r16
    ret

uart_refresh:
    sbis UCSRA, 5
    rjmp uart_refresh_end
    lds r16, output_top
    lds r17, output_pointer
    cp r16, r17
    breq uart_refresh_end
    loadZ output_buffer
    ldi r16, 0
    add ZL, r17
    adc ZH, r16
    ld r16, Z
    out UDR, r16
    inc r17
    cpi r17, buffer_size
    brne uart_refresh_not_overflow
    ldi r17, 0
uart_refresh_not_overflow:
    sts output_pointer, r17
uart_refresh_end:
    ret

uart_send:
    cli
    lds r16, output_top
    ldi r17, 0
    loadY output_buffer
    add YL, r16
    adc YH, r17
uart_send_loop:
    ld r17, Z+
    st Y+, r17
    inc r16
    cpi r16, buffer_size
    brne uart_send_not_overflow
    ldi r16, 0
    loadY output_buffer
uart_send_not_overflow:
    cpi r17, 0
    brne uart_send_loop
    sts output_top, r16
    sei
    ret
