.include "include/registers.s"

parameter PORTSegments, PORTA
parameter DDRSegments, DDRA
parameter PORTAnodes, PORTC
parameter DDRAnodes, DDRC

.global reset
.global external0
.global external1
.global timer0_overflow
.global usart_tx_complete
.global usart_rx_complete

.section .data

buffer:
    .space 64

.section .text

system_tag:
    .asciz "\r\n[SYSTEM] "
start:
   
    .asciz "Program started."
button:
    .asciz "Button clicked."
newline:
    .asciz "\r\n"
separator:
    .asciz "_"
prompt:
    .asciz "\r\n> "
command_help:
    .asciz "help\r"
command_version:
    .asciz "version\r"
command_set:
    .asciz "set "
help_output:
    .asciz "Available commands: help, version"
version_output:
    .asciz "Version 0.1 (__TIME__)"
invalid_command:
    .asciz "Invalid command. Use \"help\" to get avaliable commands."
set_output:
    .asciz "setting x"
.align 2

reset:
    load16 SP, _stack_top
    ldi r22, 0x00
	out DDRC, r22
    call system_initialize
    call uart_initialize
    print_string buffer, system_tag
    print_string buffer, start
    print_string buffer, prompt
sleep:
    sleep
    jmp sleep

timer0_overflow:
    call system_refresh
    call uart_refresh
    reti

usart_tx_complete:
    call uart_refresh
    reti

help:
    print_string buffer, help_output
    ret

version:
    print_string buffer, version_output
    ret
set:
    ld r18, Y
    mov r8, r18


    ;ldi r22,0x01
    ;out DDRC, r22
    cpi r18,49
    breq set_led2
   
    loadY buffer
    loadZ set_output
    call system_copy_string

    loadZ buffer
    ldi r16,8
    ldi r17,0
    add ZL, r16
    add ZH, r17
    mov r18,r18
    st Z,r18
    loadZ buffer
    call uart_send
    
    ret

set_led2:
 ldi r22,0x02
 out DDRC, r22





usart_rx_complete: ;obsługa przerwania 
    call uart_echo
    cpi r16, 13 ;sprawdzamy czy nie jest enterem 
    breq usart_rx_complete_parse_command
    reti
usart_rx_complete_parse_command: 
    print_string buffer, newline
    loadZ buffer
    call uart_load
    ldi r16, 0 ;dopychamy znamiem 0
    st Z, r16 ;w rejestrze z będzie ostatni znak bufora- 0 
usart_tx_complete_check_help_command: ; sprawdzamy czy nie wpisał help
    loadY buffer
    loadZ command_help
    call string_compare ;sprawdzamy czy komanda nie była help
    cpi r16, 1
    brne usart_tx_complete_check_version_command
    call help
    jmp usart_rx_complete_prompt
usart_tx_complete_check_version_command: ;sprawdzamy czy komenda nie była version 
    loadY buffer
    loadZ command_version
    call string_compare
    cpi r16, 1
    brne usart_tx_complete_check_version_set
    call version
    jmp usart_rx_complete_prompt


usart_tx_complete_check_version_set: ;sprawdzamy czy komenda nie była version 
    loadY buffer
    loadZ command_set
    call string_compare_space
    cpi r16, 1
    brne usart_rx_complete_command_not_known
    call set
    jmp usart_rx_complete_prompt

usart_rx_complete_command_not_known: ;sprawdzamy czy komanda była znana 
    print_string buffer, invalid_command
usart_rx_complete_prompt:
    print_string buffer, prompt
usart_rx_complete_end:
    reti



external0:
    reti

external1:
    call system_debounce
    print_string buffer, system_tag
    print_string buffer, button
    print_string buffer, prompt
    reti
