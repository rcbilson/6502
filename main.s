.include "defs.inc"

RAMTEST_START = $01

main:
        ldx #$ff
        txs

        jsr via_init
	jsr led_on
        jsr lcd_init
        lda #>hello
        ldy #<hello
        jsr lcd_puts

        lda #RAMTEST_START
        jmp ramtest

ramtest_success:
        jsr lcd_clear
        jsr led_off
        jmp spitest

.rodata
hello:
.asciiz "hello!"

.segment "VECTORS"
nmi:
        .word 0
reset:
        .word main
irq:
        .word 0
