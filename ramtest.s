.include "defs.inc"

.ifndef RAMTEST_START
RAMTEST_START = $0100
.endif
RAMTEST_NPAGES = 63
RAMTEST_END = RAMTEST_START + RAMTEST_NPAGES*$100

.zeropage
scratch: .res 2
ramtest_start: .res 1
ramtest_end: .res 1

.code

; https://barrgroup.com/blog/fast-accurate-memory-test-code-c

ramtest:
        sta ramtest_start
        clc
        adc #RAMTEST_NPAGES
        sta ramtest_end

; walk a single bit across the data lines
.proc data_bus_test
        ldy #0
        lda #1
        clc
loop:
        sta scratch
        cmp scratch
        bne data_bus_fail
        asl
        iny
        bcc loop
.endproc

; fill the test area with hex 55
.proc address_bus_init
        lda #$55
        ldx #0
        stx scratch
        ldx ramtest_start
        stx scratch+1
        ldx #RAMTEST_NPAGES
        ldy #$ff
loop:
        sta (scratch),Y
        dey
        bne loop
        inc scratch+1
        ldy #$ff
        dex
        bne loop
.endproc

; set address 0 to a different pattern, and verify
; that no other address changed
.proc check_stuck_low
        lda #$AA
        sta 0
        ldx #0
        stx scratch
        ldx ramtest_start
        stx scratch+1
        ldx #RAMTEST_NPAGES
        lda #$55
        ldy #$ff
loop:
        cmp (scratch),Y
        bne addr_bus_fail_lo
        dey
        bne loop
        inc scratch+1
        ldy #$ff
        dex
        bne loop
.endproc
        ; restore pattern at address 0
        lda #$55
        sta 0

; set the location at the top of the range (max address
; bits set) to a different pattern, and verify that no
; other address changed
.proc check_stuck_high
        ; set antipattern at $3fff
        ldx #0
        stx scratch
        ldx ramtest_end
        dex
        stx scratch+1
        ldy #$ff
        lda #$AA
        sta (scratch),y
        ; set up for scan
        ldx ramtest_start
        stx scratch+1
        ldx #RAMTEST_NPAGES
        lda #$55
loop:
        cmp (scratch),Y
        bne check_fail
        dey
        bne loop
        inc scratch+1
        ldy #$ff
        dex
        bne loop
        ; we should have found our antipattern
        ; but we did not
        jmp addr_bus_fail_hi
check_fail:
        ; we expect the final byte to fail
        ldx ramtest_end
        dex
        cpx scratch+1
        bne addr_bus_fail_hi
        ldx #$ff
        cpx scratch
        bne addr_bus_fail_hi
.endproc
        jmp ramtest_success

.proc data_bus_fail
        sty scratch
        pha
        jsr lcd_clear
        lda #>data_msg
        ldy #<data_msg
        jsr lcd_puts
        pla
        pha
        jsr lcd_puthex
        pla
loop:
        jsr led_code
        ldx 255
wait:
        dex
        bne wait
        jmp loop
.endproc

.proc addr_bus_fail_lo
        sty scratch
        jsr lcd_clear
        lda #>addr_lo_msg
        ldy #<addr_lo_msg
        jmp addr_bus_fail
.endproc

.proc addr_bus_fail_hi
        jmp ramtest_success
        sty scratch
        jsr lcd_clear
        lda #>addr_hi_msg
        ldy #<addr_hi_msg
        jmp addr_bus_fail
.endproc

.proc addr_bus_fail
        jsr lcd_puts
        lda scratch+1
        jsr lcd_puthex
        lda scratch
        jsr lcd_puthex
loop:
        lda scratch+1
        jsr led_code
        lda scratch
        jsr led_code
        ldx 255
wait:
        dex
        bne wait
        jmp loop
.endproc

.rodata
data_msg:
.asciiz "data:"
addr_lo_msg:
.asciiz "addr lo:"
addr_hi_msg:
.asciiz "addr hi:"
