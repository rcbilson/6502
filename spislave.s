.include "defs.inc"
.include "via.inc"

DESTINATION = $200

.zeropage
startclk: .res 1
accumulator: .res 1
.code

.macro CHECK_CE
        lda PORTA
        and #SPI_CE
.endmacro

.proc spitest
        lda #0
        sta accumulator
        lda 0
        sta r0
        lda #>DESTINATION
        sta r0+1
        ldy #<DESTINATION

        ; CE must start high
init:
        CHECK_CE
        beq init

        ; wait for master to lower CE
wait_ce:
        CHECK_CE
        bne wait_ce
        jsr led_on

next_byte:
        ldx #8

        ; wait for CLK to go high
wait_clk_hi:
        CHECK_CE
        bne spi_done
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
        bne spi_done
        lda PORTA
        and #SPI_CLK
        bne wait_clk_lo

        dex
        bne wait_clk_hi

        lda accumulator
        sta (r0),y
        iny
        bne next_byte
        inc r0+1
        jmp next_byte
.endproc

.proc spi_done
        jsr led_off
        cpy #0
        bne execute
        lda #>DESTINATION
        cmp r0+1
        bne execute
        jmp spitest
execute:
        jmp DESTINATION
.endproc
