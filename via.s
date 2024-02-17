.include "defs.inc"
.include "via.inc"

.proc via_init
        lda #%11111111 ; Set all pins on port B to output
        sta DDRB

        lda #%11100001 ; Set top 3 pins on port A to output
        sta DDRA

        rts
.endproc
