.data
	.word 100, 200

.text
	lui t0, 0
	# lui t0, 0xbfaf8
 	ori t0, t0, 0x0
	# lui t1, 0xbfaf8
	lui t1, 0
	ori t1, t1, 0x4
	lui t2, 0x0003 #0x00100000
	# lui t2, 0x00001
	lui t3, 0
	
disp:
	lw t5, (x0)
	# lui t5, 0
	add t5, t5, t3
	sw t5, (x0)
	ori t6, zero, 1
	add t3, t3, t6
	lui t4, 0

delay:
	ori t6, zero, 1
	add t4, t4, t6
	beq t4, t2, disp
	jal delay
