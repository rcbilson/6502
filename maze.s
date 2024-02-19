.include "defs.inc"

SLASH = %00101111
BACKSLASH = %01100000
DELAY = $3FFFFFFF

LINE1_INIT = $10
LINE1_START = $0
LINE1_END = $27
LINE2_INIT = LINE1_INIT + $40
LINE2_START = LINE1_START + $40
LINE2_END = LINE1_END + $40

.proc maze
        lda #>chardata
        ldy #<chardata
        jsr lcd_chars

        lda #LINE1_INIT
        sta r2
        lda #LINE2_INIT
        sta r3
loop:
        lda r2
        jsr lcd_loc
        jsr pick_sym
        jsr lcd_putc
        lda r3
        jsr lcd_loc
        jsr pick_sym
        clc
        adc #2
        jsr lcd_putc
        jsr lcd_scroll
        jsr delay
        inc r2
        inc r3
        lda #LINE1_END
        cmp r2
        bpl loop
        lda #LINE1_START
        sta r2
        lda #LINE2_START
        sta r3
        jmp loop
.endproc

.proc delay
        ldx #>DELAY
        ldy #<DELAY
loop:
        dey
        bne loop
        cpx #0
        beq done
        dex
        jmp loop
done:
        rts
.endproc

.proc pick_sym
        jsr rand
        ; our custom characters are in positions 0 and 1
        and #$01
        rts
.endproc

.rodata
chardata:
        ; top row
        .byte %00000
        .byte %10000
        .byte %00000
        .byte %10100
        .byte %00000
        .byte %00101
        .byte %00000
        .byte %00001

        .byte %00000
        .byte %00001
        .byte %00000
        .byte %00101
        .byte %00000
        .byte %10100
        .byte %00000
        .byte %10000

        ; bottom row
        .byte %10000
        .byte %00000
        .byte %10100
        .byte %00000
        .byte %00101
        .byte %00000
        .byte %00001
        .byte %00000

        .byte %00001
        .byte %00000
        .byte %00101
        .byte %00000
        .byte %10100
        .byte %00000
        .byte %10000
        .byte %00000

        .byte $ff
