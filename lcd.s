.include "defs.inc"

PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003

E  = %10000000
RW = %01000000
RS = %00100000

.proc lcd_wait
        lda #%00000000 ; Set all pins on port B to input
        sta DDRB

loop:

        lda #RW         ; Clear RS/E bits
        sta PORTA

        lda #(RW | E)  ; Set RW and E bits to check busy
        sta PORTA

        lda #0         ; Clear RS/RW/E bits
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

        lda #0         ; Clear RS/RW/E bits
        sta PORTA

        lda #E         ; Set E bit to send instruction
        sta PORTA

        lda #0         ; Clear RS/RW/E bits
        sta PORTA
        rts
.endproc

.proc lcd_data
        sta PORTB

        jsr lcd_wait

        lda #RS        ; Clear RS/RW/E bits
        sta PORTA

        lda #(RS | E)  ; Set RS and E bits to send data
        sta PORTA

        lda #0         ; Clear RS/RW/E bits
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
        jsr lcd_data
        pla
        and #$f
        TO_ASCII
        jsr lcd_data
        rts
.endproc

.proc lcd_init
        lda #%11111111 ; Set all pins on port B to output
        sta DDRB

        lda #%11100000 ; Set top 3 pins on port A to output
        sta DDRA

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
