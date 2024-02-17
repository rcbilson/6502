.include "defs.inc"

RAMTEST_START = $01

main:
        ldx #$ff
        txs

        jsr via_init
	jsr led_on
        jsr lcd_init
        lda #>testing
        ldy #<testing
        jsr lcd_puts

        lda #RAMTEST_START
        jmp ramtest

ramtest_success:
        jsr lcd_clear
        lda #>test_complete
        ldy #<test_complete
        jsr lcd_puts
        jsr led_off
loop:
        jmp loop

.rodata
testing:
.asciiz "testing"
test_complete:
.asciiz "test complete"

.segment "VECTORS"
nmi:
        .word 0
reset:
        .word main
irq:
        .word 0
