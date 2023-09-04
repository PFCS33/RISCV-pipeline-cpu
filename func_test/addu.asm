.data
    .word 1,2
.text
    lw t0, 0(x0)
    lw t1, 4(x0)
    add t3, t0, t1