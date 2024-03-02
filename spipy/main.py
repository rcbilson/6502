import gpiozero

decabd0 = gpiozero.SPIDevice(port=0, device=0)
decabd0._spi.rate = 6000

with open("in-file", "rb") as in_file:
    bytes = in_file.read()
    print(f"sending {len(bytes)} bytes")
    decabd0._spi.transfer(bytes)
    print("transfer complete")
