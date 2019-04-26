; AVR register map
.set SREG, 0x3F
.set SPH, 0x3E
.set SPL, 0x3D
.set OCR0, 0x3C
.set GICR, 0x3B
.set GIFR, 0x3A
.set TIMSK, 0x39
.set SPMCR, 0x37
.set TWCR, 0x36
.set MCUCR, 0x35
.set MCUCSR, 0x34
.set TCCR0, 0x33
.set TCNT0, 0x32
.set OCDR, 0x31
.set SFIOR, 0x30
.set TCCR1A, 0x2F
.set TCCR1B, 0x2E
.set TCNT1H, 0x2D
.set OCR1AH, 0x2B
.set OCR1AL, 0x2A
.set OCR1BH, 0x29
.set OCR1BL, 0x28
.set ICR1H, 0x27
.set ICR1L, 0x26
.set TCCR2, 0x25
.set OCR2, 0x23
.set ASSR, 0x22
.set WDTCR, 0x21
.set UCSRC, 0x20
.set UBRRH, 0x20
.set EEARH, 0x1F
.set EEARL, 0x1E
.set EECR, 0x1C
.set PORTA, 0x1B
.set DDRA, 0x1A
.set PINA, 0x19
.set PORTB, 0x18
.set DDRB, 0x17
.set PINB, 0x16
.set PORTC, 0x15
.set DDRC, 0x14
.set PINC, 0x13
.set PORTD, 0x12
.set DDRD, 0x11
.set PIND, 0x10
.set SPDR, 0x0F
.set SPSR, 0x0E
.set SPCR, 0x0D
.set UDR, 0x0C
.set ACSR, 0x08
.set UCSRA, 0x0B 
.set UCSRB, 0x0A 
.set UBRRL, 0x09
.set ADCSRA, 0x06
.set ADCH, 0x05
.set ADCL, 0x04
.set TWDR, 0x03
.set TWAR, 0x02
.set TWSR, 0x01
.set TWBR, 0x00

; Special registers
.set SP, SPL

; Macros

.macro print_string buffer, text
    loadY \buffer\()
    loadZ \text\()
    call system_copy_string
    loadZ \buffer\()
    call uart_send
.endm

.macro parameter name, value
    .set \name, \value
    .global \name
.endm

.macro load8 reg, value
	ldi r16, \value
	out \reg\(), r16
.endm

.macro load16 reg, value
	ldi r16, lo8(\value)
	out \reg\(), r16
	ldi r16, hi8(\value)
	out \reg\()+1, r16
.endm

.macro loadX value
	ldi r26, lo8(\value)
	ldi r27, hi8(\value)
.endm

.macro loadY value
	ldi r28, lo8(\value)
	ldi r29, hi8(\value)
.endm

.macro loadZ value
	ldi r30, lo8(\value)
	ldi r31, hi8(\value)
.endm
