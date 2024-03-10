.include "defs.inc"
.include "via.inc"

.proc lcd_wait
        lda #%00000000 ; Set all pins on port B to input
        sta DDRB

        lda #<~(RS | E | RW) ; Clear RS/RW/E bits
        and PORTA
        sta PORTA
loop:
        lda #RW         ; Clear RS/E bits
        ora PORTA
        sta PORTA

        lda #(RW | E)  ; Set RW and E bits to check busy
        ora PORTA
        sta PORTA

        lda #<~(RS | E | RW) ; Clear RS/RW/E bits
        and PORTA
        sta PORTA

        bit PORTB      ; Set N flag according to bit 7
        bmi loop

        lda #%11111111 ; Set all pins on port B to output
        sta DDRB
        rts
.endproc

.proc lcd_cmd
        sta PORTB

        jsr lcd_wait

        lda #<~(RS | E | RW) ; Clear RS/RW/E bits
        and PORTA
        sta PORTA

        lda #E         ; Set E bit to send instruction
        ora PORTA
        sta PORTA

        lda #<~(RS | E | RW) ; Clear RS/RW/E bits
        and PORTA
        sta PORTA
        rts
.endproc

lcd_data:
.proc lcd_putc
        sta PORTB

        jsr lcd_wait

        lda #<~(RS | E | RW) ; Clear RS/RW/E bits
        and PORTA
        sta PORTA

        lda #(RS | E)       ; Set RS and E bits to send data
        ora PORTA
        sta PORTA

        lda #<~(RS | E | RW) ; Clear RS/RW/E bits
        and PORTA
        sta PORTA
        rts
.endproc

.macro TO_ASCII
.local skip
        clc
        adc #$30
        cmp #$3A
        bcc skip
        adc #6
skip:
.endmacro

.proc lcd_puthex
        pha
        lsr
        lsr
        lsr
        lsr
        TO_ASCII
        jsr lcd_putc
        pla
        and #$f
        TO_ASCII
        jsr lcd_putc
        rts
.endproc

.proc lcd_puts
        sty r0
        sta r0+1
        ldy #0
loop:
        lda (r0),y
        beq done
        jsr lcd_putc
        iny
        jmp loop
done:
        rts
.endproc

.proc lcd_init
        lda #%00111000 ; Set 8-bit mode; 2-line display; 5x8 font
        jsr lcd_cmd
        lda #%00000001 ; Clear display
        jsr lcd_cmd
        lda #%00001110 ; Display on; cursor on; blink off
        jsr lcd_cmd
        lda #%00000110 ; Increment and shift cursor; don't shift display
        jmp lcd_cmd
.endproc

.proc lcd_home
        lda #%00000010 ; Return home
        jmp lcd_cmd
.endproc

.proc lcd_clear
        lda #%00000001 ; Clear display
        jmp lcd_cmd
.endproc

.proc lcd_loc
        ; a contains address
        ora #%10000000 ; Set DDRAM address
        jmp lcd_cmd
.endproc

.proc lcd_scroll
        ; a contains LCD_SCROLL_LEFT or LCD_SCROLL_RIGHT
        ora #%0000011000
        jmp lcd_cmd
.endproc

.proc lcd_chars
        ; a::y is pointer to character data
        sta r0+1
        lda #0
        sta r0

        lda #%01000000 ; Set CGRAM address 0
        jsr lcd_cmd
loop:
        lda (r0),y
        bmi done
        jsr lcd_data
        iny
        bne loop
        inc r0+1
        jmp loop
done:
        ; set DDRAM address for future writes
        jmp lcd_home
.endproc
