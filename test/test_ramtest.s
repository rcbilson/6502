.include "defs.inc"

.import exit

RAMTEST_START = $60

.export _main
_main:
        lda #RAMTEST_START
        jmp ramtest
ramtest_success:
        lda #0
        jmp exit
