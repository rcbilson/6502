import gpiozero

decabd0 = gpiozero.SPIDevice(port=0, device=0)
decabd0._spi.rate = 6000

while True:
        decabd0._spi.transfer([0xDE, 0xAD, 0xBE, 0xEF])
