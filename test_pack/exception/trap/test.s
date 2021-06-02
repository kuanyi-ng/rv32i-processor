.text
main:
	li x1, 0xf0000000
	lui x2, %hi(START_MESSAGE)
	addi x2, x2, %lo(START_MESSAGE)
P_START_MESSAGE:
	lb 	x3, 0(x2)
	beqz x3, ECALL
	sb 	x3, 0(x1)
	addi x2, x2, 1
	j 	P_START_MESSAGE
ECALL:	
	ecall
	lui x2, %hi(CHECK_PASSED)
	addi x2, x2, %lo(CHECK_PASSED)
P_END_MESSAGE:
	lb 	x3, 0(x2)
	beqz x3, EXIT
	sb	x3, 0(x1)
	addi x2, x2, 1
	j P_END_MESSAGE
EXIT:
	li x1, 0xff000000
	sw x0, 0(x1)

.section .rodata
START_MESSAGE:
.string "TRAP TEST\n"
CHECK_PASSED:
.string "CHECK PASSED!!\n"
