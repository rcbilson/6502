

.proc oldramtest
        ldx #$0
        stx 0
        inx
mainloop:
        inx
        cpx #NPAGES
        bcc noreset
        ldx #2
noreset:
        jsr lcd_home
        txa
        jsr lcd_puthex
        stx 1
        ldy #$ff
pageloop:
        tya
        sta (0),Y
        cmp (0),Y
        bne fail
        dey
        bne pageloop
        jmp mainloop

fail:
        tya
        jsr lcd_puthex
endless:
        jmp endless
.endproc
