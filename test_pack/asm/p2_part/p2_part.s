	.text
main:
	li	x16,	0x80010000

	lb	x8,	0x60(x16)
	lb	x9,	0x61(x16)
	sltu	x10,	x8,	x9
	xor	x10,	x10,	x10
	ori	x10,	x10,	0x1

    # =====
    # x8: ffff_fff5 (-11)
    # x9: ffff_fff3 (-13)
    # x10: 0000_0001
    # =====

	j	L32
	sb	x10,	0x6c(x16)
L1:
	jal	L2
    # jump to L2
    # x31: addr [ sb x10, 0x6d(x16) ]
	sb	x10,	0x6d(x16)
	jr	x31
    # jump to addr [ xor x8, x8, x8 ]
L2:
	ori	x10,	x10,	0x3
	jalr	x31
    # jump to addr [ sb x10, 0x6d(x16) ]
    # x31: addr [ xor x8, x8, x8 ]

    # =====
    # x10: 0000_0003
    # =====
L3:
	xor	x8,	x8,	x8
	addi	x8,	x8,	0x03
	xor	x9,	x9,	x9
	addi	x9,	x9,	-1
	beq	x8,	x8,	L4
	sb	x10,	0x6e(x16)

    # =====
    # x8: 0000_0003
    # x9: ffff_ffff
    # branch to L4
    # =====
L4:
	beq	x8,	x9,	L5
	sb	x10,	0x6f(x16)

    # =====
    # doesn't branch to L5
    # =====

L5:
	bne	x8,	x8,	L6
	sb	x10,	0x70(x16)

    # =====
    # doesn't branch to L6
    # =====

L6:
	bne	x8,	x9,	L7
	sb	x10,	0x71(x16)

    # =====
    # branch to L7
    # =====

L7:
    # branch <= 0
	blez	x8,	L8
	sb	x10,	0x72(x16)

    # =====
    # doesn't branch to L8
    # =====

L8:
	blez	x0,	L9
	sb	x10,	0x73(x16)

    # =====
    # branch to L9
    # =====

L9:
	blez	x9,	L10
	sb	x10,	0x74(x16)

    # =====
    # branch to L10
    # =====

L10:
    # branch > 0
	bgtz	x8,	L11
	sb	x10,	0x75(x16)

    # =====
    # branch to L11
    # =====

L11:
	bgtz	x0,	L12
	sb	x10,	0x76(x16)

    # =====
    # doesn't branch to L12
    # =====

L12:
	bgtz	x9,	L13
	sb	x10,	0x77(x16)
    
    # =====
    # doesn't branch to L13
    # =====

L13:
    # branch >= 0
	bgez	x8,	L14
	sb	x10,	0x78(x16)

    # =====
    # branch to L14
    # =====

L14:
	bgez	x0,	L15
	sb	x10,	0x79(x16)

    # =====
    # branch to L15
    # =====

L15:
	bgez	x9,	L16
	sb	x10,	0x7a(x16)

    # =====
    # doesn't branch to L16
    # =====

L16:
    # branch < 0
	bltz	x8,	M1
	jal	L17

    # =====
    # doesn't branch to M1
    # jump to L17
    # =====

M1:
	sb	x10,	0x7b(x16)
L17:
	bltz	x0,	M2
	jal	L18

    # =====
    # doesn't branch to M2
    # jump to L18
    # =====

M2:
	sb	x10,	0x7c(x16)
L18:
	bltz	x9,	M3
	jal L19

    # =====
    # branch to M3
    # =====

M3:
	sb	x10,	0x7d(x16)
L19:
	bltz	x0,	M4
	jal L20

    # =====
    # doesn't branch to M4
    # jump to L20
    # =====

M4:
	sb	x10,	0x7e(x16)
	j	L21
L20:
	ori	x10,	x10,	0x7
	jr	x31

    # =====
    # x10: 0000_0007
    # =====

L21:
	bltz	x8,	L22
	sb	x10,	0x7f(x16)
L22:
	bltz	x0,	L23
	sb	x10,	0x80(x16)
L23:
	bltz	x9,	L24
	sb	x10,	0x81(x16)
L24:
	bgez	x8,	M5
	jal L25
M5:
	sb	x10,	0x82(x16)
L25:
	bgez	x0,	M6
	jal L26
M6:
	sb	x10,	0x83(x16)
L26:
	bgez	x9,	M7
	jal L27
M7:
	sb	x10,	0x84(x16)
L27:
	bgez	x9,	M8
	jal L28
M8:
	sb	x10,	0x85(x16)
	j	L29
L28:
	ori	x10,	x10,	0xf
	jr	x31
L29:
	jal	L30
	j	L31
L30:
	jr	x31
L31:
	ori	x10,	x10,	0x1f
	sb	x10,	0x86(x16)
L32:
	li	x30, 0xFF000000
	sw	x0, 0x0(x30)
	beq	x0,	x0,	L32

	.data
	.word	0x3040000	# @10000
	.word	0x0		# @10004
	.word	0x9ff0000	# @10008
	.word	0x0		# @1000c
	.word	0xffff0123	# @10010
	.word	0x0		# @10014
	.word	0x1232400	# @10018
	.word	0xff00f0f0	# @1001c
	.word	0x0		# @10020
	.word	0x0		# @10024
	.word	0x0		# @10028
	.word	0x0		# @1002c
	.word	0x0		# @10030
	.word	0x0		# @10034
	.word	0x0		# @10038
	.word	0xf0f00f00	# @1003c
	.word	0x0		# @10040
	.word	0x0		# @10044
	.word	0x0		# @10048
	.word	0x0		# @1004c
	.word	0x0		# @10050
	.word	0x0		# @10054
	.word	0x0		# @10058
	.word	0x0		# @1005c
	.word	0x305f3f5	# @10060
	.word	0x0		# @10064
	.word	0x0		# @10068

