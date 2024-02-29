.PC02

; main.s
.globalzp r0, r1, r2, r3

; lfsr.s
.global srand
.global rand

; via.s
.global via_init

; lcd.s
.global lcd_init
.global lcd_home
.global lcd_clear
.global lcd_puthex
.global lcd_putc
.global lcd_puts
.global lcd_loc
.global lcd_scroll
LCD_SCROLL_LEFT = %000
LCD_SCROLL_RIGHT = %100
.global lcd_chars

; led.s
.global led_on
.global led_off
.global led_blink
.global led_code

; ramtest.s
.global ramtest
.global ramtest_success

; maze.s
.global maze

; spislave.s
.global spitest
