.include "defs.inc"

.zeropage
seed: .byte 0

.code
.proc srand
        sta seed
        rts
.endproc

.proc rand
        lda seed
        lsr
        bcc noeor
        eor #$b4
noeor:
        sta seed
        rts
.endproc
