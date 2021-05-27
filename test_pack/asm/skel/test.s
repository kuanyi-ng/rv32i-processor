	.text    # text section
main:
    # main program

loop:
    li  x30, 0xff000000
    sw  x0, 0x0(x30)
    beq x0, x0, loop

	.data    # data section
