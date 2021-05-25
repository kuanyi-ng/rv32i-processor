	.text    # text section
main:
    # main program
    add x21, x0, x0
    li  x21, 0x80010000

    csrr x8, misa
    sw  x8, 0x4(x21)

loop:
	li	x30, 0xff000000
	sw	x0, 0x0(x30)
	beq	x0,	x0,	loop

	.data    # data section
    .word   0x1028182   # @10000
