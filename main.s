.include "defs.inc"

main:
        jmp ramtest

ramtest_success:
        jmp ramtest_success

.segment "VECTORS"
nmi:
        .word 0
reset:
        .word main
irq:
        .word 0
