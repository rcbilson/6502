.include "../defs.inc"

.import exit

.export _main
_main:
        lda #114
        jsr srand
        jsr rand
        eor #57
        jmp exit
