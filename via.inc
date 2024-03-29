PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003
VIA1_T1CL = $6004
VIA1_T1CH = $6005
VIA1_T1LL = $6006
VIA1_T1LH = $6007
VIA1_T2CL = $6008
VIA1_T2CH = $6009
VIA1_SR = $600A
VIA1_ACR = $600B
VIA1_PCR = $600C
VIA1_IFR = $600D
VIA1_IER = $600E

; PORTA
E  = %10000000
RW = %01000000
RS = %00100000

LED = %00000001

SPI_CE   = %00000010 ; brown
SPI_MISO = %00000100 ; orange
SPI_MOSI = %00001000 ; red
SPI_CLK  = %00010000 ; yellow
