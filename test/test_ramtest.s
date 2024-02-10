.include "defs.inc"

.import exit

.export _main
_main:
        jmp ramtest
ramtest_success:
        jmp exit
