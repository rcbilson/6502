PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003

E  = %10000000
RW = %01000000
RS = %00100000

NPAGES = 64

LCD_WAIT: .macro
  lda #%00000000 ; Set all pins on port B to input
  sta DDRB

loop\@:

  lda #RW         ; Clear RS/E bits
  sta PORTA

  lda #(RW | E)  ; Set RW and E bits to check busy
  sta PORTA

  lda #0         ; Clear RS/RW/E bits
  sta PORTA

  bit PORTB      ; Set N flag according to bit 7
  bmi loop\@

  lda #%11111111 ; Set all pins on port B to output
  sta DDRB
.endm

SEND_CMD: .macro
  lda \1
  sta PORTB

  LCD_WAIT

  lda #0         ; Clear RS/RW/E bits
  sta PORTA

  lda #E         ; Set E bit to send instruction
  sta PORTA

  lda #0         ; Clear RS/RW/E bits
  sta PORTA
.endm

SEND_DATA: .macro
  sta PORTB

  LCD_WAIT

  lda #RS        ; Clear RS/RW/E bits
  sta PORTA

  lda #(RS | E)  ; Set RS and E bits to send data
  sta PORTA

  lda #0         ; Clear RS/RW/E bits
  sta PORTA
.endm

SEND_DATA_IMM: .macro
  lda \1
  SEND_DATA
.endm

TO_ASCII: .macro
  clc
  adc #$30
  cmp #$3A
  bcc skip\@
  adc #6
skip\@:
.endm

PRINT: .macro
  \1
  lsr
  lsr
  lsr
  lsr
  TO_ASCII
  SEND_DATA
  \1
  and #$f
  TO_ASCII
  SEND_DATA
.endm

PRINT_Y: .macro
  PRINT tya
.endm

PRINT_X: .macro
  PRINT txa
.endm

  .org $8000
reset:
  lda #%11111111 ; Set all pins on port B to output
  sta DDRB

  lda #%11100000 ; Set top 3 pins on port A to output
  sta DDRA

  SEND_CMD #%00111000 ; Set 8-bit mode; 2-line display; 5x8 font
  SEND_CMD #%00000001 ; Clear display
  SEND_CMD #%00001110 ; Display on; cursor on; blink off
  SEND_CMD #%00000110 ; Increment and shift cursor; don't shift display

  ldx #$0
  stx 0
mainloop:
  inx
  cpx #NPAGES
  bne noreset
  ldx #1
noreset:
  SEND_CMD #%00000010 ; Return home
  PRINT_X
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
  PRINT_Y
endless:
  jmp endless

  .org $fffc
  .word reset
  .word $0000
