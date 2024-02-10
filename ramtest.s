.include "defs.inc"

.ifndef RAMTEST_START
RAMTEST_START = $0100
.endif
RAMTEST_NPAGES = 63
RAMTEST_END = RAMTEST_START + RAMTEST_NPAGES*$100
SCRATCH = 2
SCRATCH_LO = SCRATCH
SCRATCH_HI = SCRATCH+1

; https://barrgroup.com/blog/fast-accurate-memory-test-code-c

ramtest:

.proc data_bus_test
        ldy #0
        lda #1
        clc
loop:
        sta 0
        cmp 0
        bne data_bus_fail
        asl
        iny
        bcc loop
.endproc

.proc address_bus_init
        lda #$55
        ldx #0
        stx SCRATCH_LO
        ldx #>RAMTEST_START
        stx SCRATCH_HI
        ldx #RAMTEST_NPAGES
mainloop:
        ldy #$ff
pageloop:
        sta (SCRATCH),Y
        dey
        bne pageloop
        inc SCRATCH_HI
        cpx SCRATCH_HI
        bcs mainloop
.endproc

.proc check_stuck_low
        lda #$AA
        sta 0
        ldx #0
        stx SCRATCH_LO
        ldx #>RAMTEST_START
        stx SCRATCH_HI
        ldx #RAMTEST_NPAGES
        lda #$55
mainloop:
        ldy #$ff
pageloop:
        cmp (SCRATCH),Y
        bne addr_bus_fail
        dey
        bne pageloop
        inc SCRATCH_HI
        cpx SCRATCH_HI
        bcs mainloop
.endproc
        lda #0
        jmp ramtest_success

.proc check_stuck_high
        ; restore pattern at address 0
        lda #$55
        sta 0
        ; set antipattern at $3fff
        lda #$AA
        sta RAMTEST_END-1
        ; start at address 3fff and go down
        ; skip zero page
        ldx #(>RAMTEST_END-1)
        stx SCRATCH_HI
        ldx #0
        stx SCRATCH_LO
        lda #$55
mainloop:
        ldy #$ff
        cpy #(>RAMTEST_END-1)
        bne pageloop
        ; skip the known antipattern
        dey
pageloop:
        cmp (SCRATCH),Y
        bne addr_bus_fail
        dey
        bne pageloop
        dec SCRATCH_HI
        beq mainloop
.endproc
        jmp ramtest_success

.proc data_bus_fail
loop:
        jmp loop
.endproc

.proc addr_bus_fail
loop:
        jmp loop
.endproc
