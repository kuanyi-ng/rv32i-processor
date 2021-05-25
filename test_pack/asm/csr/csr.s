	.text    # text section
main:
    # main program
    add x21, x0, x0
    li  x21, 0x80010000

    csrr x8, mvendorid
    sw  x8, 0x4(x21)

    csrr x8, marchid
    sw  x8, 0x8(x21)

    csrr x8, mimpid
    sw  x8, 0xc(x21)

    csrr x8, mhartid
    sw  x8, 0x10(x21)

    csrr x8, mstatus
    sw  x8, 0x14(x21)

    csrr x8, misa
    sw  x8, 0x18(x21)

    csrr x8, mie
    sw  x8, 0x1c(x21)

    csrr x8, mtvec
    sw  x8, 0x20(x21)

    csrr x8, mcounteren
    sw  x8, 0x24(x21)

    csrr x8, mscratch
    sw  x8, 0x24(x21)

    csrr x8, mepc
    sw  x8, 0x24(x21)

    csrr x8, mcause
    sw  x8, 0x24(x21)

    csrr x8, mtval
    sw  x8, 0x24(x21)

    csrr x8, mip
    sw  x8, 0x24(x21)

loop:
	li	x30, 0xff000000
	sw	x0, 0x0(x30)
	beq	x0,	x0,	loop

	.data    # data section
    .word   0x1028182   # @10000
