.include "defs.inc"
.include "via.inc"

.zeropage
startclk: .res 1
accumulator: .res 1
.code

.macro CHECK_CE
        lda PORTA
        and SPI_CE
.endmacro

.proc spitest
        lda #0
        sta accumulator

        ; wait for master to raise CE
wait_ce:
        ;jsr lcd_home
        ;lda PORTA+1
        ;jsr lcd_puthex
        ;lda PORTA
        ;jsr lcd_puthex
        CHECK_CE
        bne wait_ce

        ldx #8

        ; wait for CLK to go high
wait_clk_hi:
        CHECK_CE
        bne spitest
        lda PORTA
        and #SPI_CLK
        beq wait_clk_hi
        lda PORTA
        clc
        and #SPI_MOSI
        beq add_bit
        sec
add_bit:
        rol accumulator

        ; wait for CLK to go low
wait_clk_lo:
        CHECK_CE
        bne spitest
        lda PORTA
        and #SPI_CLK
        bne wait_clk_lo

        dex
        bne wait_clk_hi

        lda accumulator
        jsr lcd_puthex

        jmp spitest
.endproc
