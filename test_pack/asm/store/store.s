.global main

	.text
main:
	li	x16,	0x80010000
	lw	x8,	0x0(x16)
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

