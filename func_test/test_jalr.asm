.data

.text
    addi t0, zero, test_pos
    jalr x1, t0
    jal end
.test_pos:
    addi a0, zero, 0xa
    jal x1
.end:
