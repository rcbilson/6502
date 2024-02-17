.include "defs.inc"
.include "via.inc"

.proc led_on
        lda #LED
        sta PORTA
        rts
.endproc

.proc led_off
        lda #0
        sta PORTA
        rts
.endproc

.macro DELAY
.local outer_loop
.local inner_loop
        sty 0
        ;lsl 0
        ;lsl 0
        ;lsl 0
outer_loop:
        ldy #$ff
inner_loop:
        dey
        bne inner_loop
        dec 0
        bne outer_loop
.endmacro

.proc led_blink
        tay
        lda #LED
        sta PORTA
        DELAY
        lda #0
        sta PORTA
        rts
.endproc

.proc led_code
        sec
nextbit:
        ldy #$A0
        rol
        beq done
        bcc blink
        ldy #$50
blink:
        tax
        tya
        jsr led_blink
        txa
        DELAY
        clc
        jmp nextbit
done:
        rts
.endproc
