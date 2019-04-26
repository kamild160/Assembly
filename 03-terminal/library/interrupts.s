.global empty_handler

.macro	vector name
    .weak \name
    .set \name, empty_handler
    jmp \name
.endm

.section .interrupts
interrupt_vectors:
    vector reset
    vector external0
    vector external1
    vector external2
    vector timer2_compare
    vector timer2_overflow
    vector timer1_capture
    vector timer1_compareA
    vector timer1_compareB
    vector timer1_overflow
    vector timer0_compare
    vector timer0_overflow
    vector spi_complete
    vector usart_rx_complete
    vector usart_data_empty
    vector usart_tx_complete
    vector adc_complete

empty_handler:
    reti
