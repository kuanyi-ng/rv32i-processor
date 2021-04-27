	.text
main:
	li	x16,	0x80010000
	# delay 2 cycles
	li	x16,	0x80010000
	li	x16,	0x80010000
	# (end) delay 2 cycles
	lw	x8,	0x0(x16)
	# delay 2 cycles
	lw	x8,	0x0(x16)
	lw	x8,	0x0(x16)
	# (end) delay 2 cycles
	sw	x8,	0x4(x16)
	sh	x8,	0x8(x16)
	sh	x8,	0xa(x16)
	sb	x8,	0xc(x16)
	sb	x8,	0xd(x16)
	sb	x8,	0xe(x16)
	sb	x8,	0xf(x16)
Loop:
	li	x30, 0xff000000
	sw	x0, 0x0(x30)
	beq	x0,	x0,	Loop

	.data
	.word	0x1028182	# @10000

