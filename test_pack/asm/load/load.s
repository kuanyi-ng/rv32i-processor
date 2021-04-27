	.text
main:
	add	x21, x0, x0
	li	x21, 0x80010000
	# make li wait for 2 cycles
	li	x21, 0x80010000
	li	x21, 0x80010000
	# (end) make li wait for 2 cycles
	lw	x8,	0x0(x21)
	lh	x9,	0x0(x21)
	lh	x10, 0x2(x21)
	lhu	x11, 0x0(x21)
	lhu	x12, 0x2(x21)
	lb	x13, 0x0(x21)
	lb	x14, 0x1(x21)
	lb	x15, 0x2(x21)
	lb	x16, 0x3(x21)
	lbu	x17, 0x0(x21)
	lbu	x18, 0x1(x21)
	lbu	x19, 0x2(x21)
	lbu	x20, 0x3(x21)
	li	x22, 0xFF000000
	# make li wait for 2 cycles
	li	x22, 0xFF000000
	li	x22, 0xFF000000
	# (end) make li wait for 2 cycles
	sw	x0, 0x0(x22)

	.data
	.word	0x1028182	# @10000

