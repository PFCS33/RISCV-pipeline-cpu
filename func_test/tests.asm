.data
	#.word 0x12345

.text
    bne     zero, zero, error
    beq     zero, zero, beq_temp_ok
    jal     error
.beq_temp_ok:
    ori     t0, zero, 0xfff     # t0 = 0xffff ffff
    beq     t0, zero, error
    bne     t0, zero, ori_temp_ok
    jal     error
.ori_temp_ok:
    ori     t0, zero, 0x0       # t0 = 0x0
    bne     t0, zero, error
    beq     t0, zero, bne_temp_ok
    jal     error
.bne_temp_ok_ok:

#

    ori     t0, zero, 0xfff     # t0 = 0xffff ffff
    ori     t1, zero, 0x1       # t1 = 0x1
    add     t2, t0, t1          # t2 = 0xffff ffff + 0x1 // 0x0
    bne     t2, zero, add_error
    ori     t1, zero, 0x2       # t1 = 0x2
    add     t2, t0, t1          # t2 = 0xffff ffff + 0x2 // 0x1
    ori     t3, zero, 0x1       # t3 = 0x1
    bne     t2, t3, add_error
	ori     t0, zero, 0x300     # t0 = 0x300
	ori     t1, zero, 0x55      # t1 = 0x55
	add     t2, t0, t1          # t2 = t0 + t1 // 0x355
	ori     t3, t3, 0x355       # t3 = 0x355
    beq     t2, t3, add_ok
.add_error:
    ori     a0, zero, 0x2
    jal     error
.add_ok:

    ori     t0, zero, 0x0       # t0 = 0x0
    ori     t1, zero, 0x1       # t1 = 0x1
    sub     t2, t0, t1          # t2 = t0 - t1 // 0xffff ffff
    ori     t3, zero, 0xfff     # t3 = 0xffff ffff
    bne     t2, t3, sub_error
	ori     t0, zero, 0x300     # t0 = 0x300
	ori     t1, zero, 0x55      # t1 = 0x55
    sub     t2, t0, t1          # t2 = t0 - t1 //0x2ab
    ori     t3, zero, 0x2ab     # t3 = 0x2ab
    beq     t2, t3, sub_ok
.sub_error:
    ori     a0, zero, 0x3
    jal     error
.sub_ok:

    ori     t0, zero, 0xfff     # t0 = 0xffff ffff
    addi    t2, t0, 0x1         # t2 = t0 + 0x1 // 0x0
    bne     t2, zero, addi_error
    addi    t2, t0, 0x2         # t2 = t0 + 0x2 // 0x1
    ori     t3, zero, 0x1       # t3 = 0x1
    bne     t2, t3, addi_error
	ori     t0, zero, 0x300     # t0 = 0x300
    addi    t2, t0, 0x54        # t2 = t0 + 0x54 //0x354
    ori     t3, zero, 0x354     # t3 = 0x354
    beq     t2, t3, addi_ok
.addi_error:
    ori     a0, zero, 0x4
    jal     error
.addi_ok:

#

	addi    t0, zero, 0x300     # t0 = 0x300
    addi    t1, zero, 0x9       # t1 = 0x9
    srl     t2, t0, t1          # t2 = t0 >>l t1[4:0] // 0x300 >>l 0x9 => 0x1
    addi    t3, zero, 0x1       # t3 = 0x1
    bne     t2, t3, srl_error
    addi    t1, zero, 0xf28     # t1 = 0xffff ff28
    srl     t2, t0, t1          # t2 = t0 >>l t1[4:0] // 0x300 >>l 0x8 => 0x3
    addi    t3, zero, 0x3       # t3 = 0x3
    bne     t2, t3, srl_error
    addi    t0, zero, 0x800     # t0 = 0xffff f800
    addi    t1, zero, 0xf38     # t1 = 0xffff ff38
    srl     t2, t0, t1          # t2 = t0 >>l t1[4:0] // 0xffff f800 >>l 0x18 => 0xff
    addi    t3, zero, 0xff      # t3 = 0xff
    beq     t2, t3, srl_ok
.srl_error:
    addi    a0, zero, 0x8
    jal     error
.srl_ok:

    addi    t0, zero, 0xa       # t0 = 0xa
    addi    t1, zero, 0xf61     # t1 = 0xffff ff61
    sra     t2, t0, t1          # t2 = t0 >>a t1[4:0] // 0xa >>a 0x1 => 0x5
    addi    t3, zero, 0x5       # t3 = 0x5
    bne     t2, t3, sra_error
    addi    t0, zero, 0x801     # t0 = 0xffff f801
    addi    t1, zero, 0x8
    sra     t2, t0, t1          # t2 = t0 >>a t1[4:0] // 0xffff f801 >>a 0x8 => 0xffff fff8
    addi    t3, zero, 0xff8     # t3 = 0xffff fff8
    beq     t2, t3, sra_ok
.sra_error:
    addi    a0, zero, 0x7
    jal     error
.sra_ok:

    addi    t0, zero, 0xf00     # t0 = 0xffff ff00
    addi    t1, zero, 0x18      # t1 = 0x18
    sll     t2, t0, t1          # t2 = t0 <<l t1 // 0xffff ff00 <<l 0x18 => 0x0
    addi    t3, zero, 0x0       # t3 = 0x0
    bne     t2, t3, sll_error
    addi    t1, zero, 0x4       # t1 = 0x4
    sll     t2, t0, t1          # t2 = t0 <<l t1 // 0xffff ff00 <<l 0x4 => 0xffff f000
    addi    t3, zero, 0x7ff     # t3 = 0x7ff
    add     t3, t3, t3          # t3 = 0xffe
    addi    t3, t3, 0x2         # t3 = 0x1000
    sub     t3, zero, t3        # t3 = 0xffff f000
    bne     t2, t3, sll_error
    addi    t0, zero, 0x300     # t0 = 0x300
    addi    t1, zero, 0x55      # t1 = 0x55
    sll     t2, t0, t1          # t2 = t0 <<l t1[4:0] // 0x300 <<l 0x15 => 0x6000 0000
    addi    t4, zero, 0x1c      # t4 = 0x1c
    sra     t2, t2, t4          # t2 = t2 >>a t4[4:0] // 0x6000 0000 >>a 0x1c => 0x6
    addi    t3, zero, 0x6       # t3 = 0x6
    beq     t2, t3, sll_ok
.sll_error:
    addi    a0, zero, 0x5
    jal     error
.sll_ok:

    addi    t0, zero, 0x300     # t0 = 0x300
    srli    t2, t0, 0x7         # t2 = t0 >>l 0x7 // 0x300 >>l 0x7 => 0x6
    addi    t3, zero, 0x6       # t3 = 0x6
    bne     t2, t3, srli_error
    addi    t0, zero, 0x801     # t0 = 0xffff f801
    srli    t2, t0, 0x1d        # t2 = t0 >>l 0x1d // 0xffff f801 >>l 0x1d => 0x7
    addi    t3, zero, 0x7       # t3 = 0x7
    beq     t2, t3, srli_ok
.srli_error:
    addi    a0, zero, 0x9
    jal     error
.srli_ok:

    addi    t0, zero, 0x801     # t0 = 0xffff f801
    srai    t2, t0, 0x9         # t2 = t0 >>a 0x9 // 0xffff f801 >>a 0x9 => 0xffff fffc
    addi    t3, zero, 0xffc     # t3 = 0xffff fffc
    bne     t2, t3, srai_error
    srai    t2, t0, 0x1d        # t2 = t0 >>a 0x1d // 0xffff f801 >>a 0x1d => 0xffff ffff
    addi    t3, zero, 0xfff     # t3 = 0xffff ffff
    beq     t2, t3, srai_ok
.srai_error:
    addi    a0, zero, 0xa
    jal     error
.srai_ok:

    addi    t0, zero, 0xf00     # t0 = 0xffff ff00
    slli    t2, t0, 0x18        # t2 = t0 <<l 0x18 // 0xffff ff00 <<l 0x18 => 0x0
    addi    t3, zero, 0x0       # t3 = 0x0
    bne     t2, t3, slli_error
    slli    t2, t0, 0x8         # t2 = t0 <<l 0x8 // 0xffff ff00 <<l 0x8 => 0xffff 0000
    addi    t3, zero, 0x8       # t3 = 0x8
    sll     t3, t0, t3          # t3 = t0 <<l t3 // 0xffff ff00 <<l 0x8 => 0xffff 0000
    bne     t2, t3, slli_error
    slli    t2, t0, 0x16        # t2 = t0 <<l 0x16 // 0x300 <<l 0x16 => 0xc000 0000
    srai    t2, t2, 0x1d        # t2 = t2 >>a 0x1d // 0xc000 0000 >>a => 0xffff fffe
    addi    t3, zero, 0xffe     # t3 = 0xffff fffe
    beq     t2, t3, slli_ok
.slli_error:
    addi    a0, zero, 0x6
    jal     error
.slli_ok:

    addi    t0, zero, 0xfff     # t0 = 0xffff ffff => -1
    slt     t2, t0, zero        # t2 = t0 < 0 // -1 < 0 => 1
    addi    t3, zero, 0x1       # t3 = 0x1
    bne     t2, t3, slt_error
    addi    t1, zero, 0x1       # t1 = 0x1
    slt     t2, t0, t1          # t2 = t0 < t1 // -1 < 1 => 1
    bne     t2, t3, slt_error
    slt     t2, t1, zero        # t2 = t1 < 0 // 1 < 0 => 0
    addi    t3, zero, 0x0       # t3 = 0x0
    bne     t2, t3, slt_error
    addi    t0, zero, 0x7ff     # t0 = 0x7ff
    slt     t2, t0, t1          # t2 = t0 < t1 // 0x7ff < 1 => 0
    bne     t2, t3, slt_error
    addi    t0, zero, 0xfff     # t0 = 0xffff ffff => -1
    addi    t1, zero, 0xffe     # t1 = 0xffff fffe => -2
    slt     t2, t0, t1          # t2 = t0 < t1 // -1 < -2 => 0
    beq     t2, t3, slt_ok
.slt_error:
    addi    a0, zero, 0xb
    jal     error
.slt_ok:

    addi    t0, zero, 0xfff     # t0 = 0xffff ffff => -1
    slti    t2, t0, 0x0         # t2 = t0 < 0x0 // -1 < 0 => 1
    addi    t3, zero, 0x1       # t3 = 0x1
    bne     t2, t3, slti_error
    slti    t2, t0, 0x1         # t2 = t0 < 0x1 // -1 < 1 => 1
    bne     t2, t3, slti_error
    slti    t2, t0, 0xffe       # t2 = t0 < 0xffff fffe => -2 // -1 < -2 => 0
    addi    t3, zero, 0x0       # t3 = 0x0
    bne     t2, t3, slti_error
    addi    t0, zero, 0x7ff     # t0 = 0x7ff
    slti    t2, t0, 0x0         # t2 = t0 < 0x0 // 0x7ff < 0x0 => 0
    bne     t2, t3, slti_error
    slti    t2, t0, 0x8         # t2 = t0 < 0x8 // 0x7ff < 0x8 => 0
    beq     t2, t3, slti_ok
.slti_error:
    addi    a0, zero, 0xc
    jal     error
.slti_ok:

    addi    t0, zero, 0xfff     # t0 = 0xffff ffff
    addi    t1, zero, 0x0       # t1 = 0x0
    sltu    t2, t0, t1          # t2 = t0 < t1 // 0xffff ffff < 0x0 => 0
    addi    t3, zero, 0x0       # t3 = 0x0
    bne     t2, t3, sltu_error
    addi    t1, zero, 0x1       # t1 = 0x1
    sltu    t2, t0, t1          # t2 = t0 < t1 // 0xffff ffff < 0x1 => 0
    bne     t2, t3, sltu_error
    addi    t1, zero, 0xff0     # t1 = 0xffff fff0
    sltu    t2, t0, t1          # t2 = t0 < t1 // 0xffff ffff < 0xffff fff0 => 0
    bne     t2, t3, sltu_error
    addi    t0, zero, 0x7ff     # t0 = 0x7ff
    addi    t1, zero, 0xff      # t1 = 0xff
    sltu    t2, t0, t1          # t2 = t0 < t1 // 0x7ff < 0xff => 0
    beq     t2, t3, sltu_ok
.sltu_error:
    addi    a0, zero, 0xd
    jal     error
.sltu_ok:

    addi    t0, zero, 0xfff     # t0 = 0xffff ffff
    sltiu   t2, t0, 0x0         # t2 = t0 < 0x0 // 0xffff ffff < 0x0 => 0
    addi    t3, zero, 0x0       # t3 = 0x0
    bne     t2, t3, sltiu_error
    sltiu   t2, t0, 0x1         # t2 = t0 < 0x1 // 0xffff ffff < 0x1 => 0
    bne     t2, t3, sltiu_error
    sltiu   t2, t0, 0xff0       # t2 = t0 < 0xffff fff0 // 0xffff ffff < 0xffff fff0 => 0
    bne     t2, t3, sltiu_error
    addi    t0, zero, 0x7ff     # t0 = 0x7ff
    sltiu   t2, t0, 0xff        # t2 = t0 < 0xff // 0x7ff < 0xff => 0
    beq     t2, t3, sltiu_ok
.sltiu_error:
    addi    a0, zero, 0xe
    jal     error
.sltiu_ok:

    addi    t0, zero, 0x0       # t0 = 0x0
    addi    t1, zero, 0x0       # t1 = 0x0
    or      t2, t0, t1          # t2 = t0 | t1 // 0x0 | 0x0 => 0x0
    addi    t3, zero, 0x0       # t3 = 0x0
    bne     t2, t3, or_error
    addi    t1, zero, 0x1       # t1 = 0x1
    or      t2, t0, t1          # t2 = t0 | t1 // 0x0 | 0x1 => 0x1
    addi    t3, zero, 0x1       # t3 = 0x1
    bne     t2, t3, or_error
    addi    t1, zero, 0xfff     # t1 = 0xffff ffff
    or      t2, t0, t1          # t2 = t0 | t1 // 0x0 | 0xffff ffff => 0xffff ffff
    addi    t3, zero, 0xfff     # t3 = 0xffff ffff
    bne     t2, t3, or_error
    addi    t1, zero, 0xf00     # t1 = 0xffff ff00
    or      t2, t0, t1          # t2 = t0 | t1 // 0x0 | 0xffff ff00 => 0xffff ff00
    addi    t3, zero, 0xf00     # t3 = 0xffff ff00
    bne     t2, t3, or_error
    addi    t0, zero, 0xff      # t0 = 0xff
    or      t2, t0, t1          # t2 = t0 | t1 // 0xffff ff00 | 0xff => 0xffff ffff
    addi    t3, zero, 0xfff     # t3 = 0xffff ffff
    bne     t2, t3, or_error
    addi    t1, zero, 0x1       # t1 = 0x1
    or      t2, t0, t1          # t2 = t0 | t1 // 0xff | 0x1 => 0xff
    addi    t3, zero, 0xff      # t3 = 0xff
    beq     t2, t3, or_ok


.or_error:
    addi    a0, zero, 0xf
    jal     error
.or_ok:

    addi    t0, zero, 0x0       # t0 = 0x0
    addi    t1, zero, 0x0       # t1 = 0x0
    and     t2, t0, t1          # t2 = t0 & t1 // 0x0 & 0x0 => 0x0
    addi    t3, zero, 0x0       # t3 = 0x0
    bne     t2, t3, and_error
    addi    t1, zero, 0xfff     # t1 = 0xffff ffff
    and     t2, t0, t1          # t2 = t0 & t1 // 0x0 & 0xffff ffff => 0x0
    bne     t2, t3, and_error
    addi    t0, zero, 0x114     # t0 = 0x114
    and     t2, t0, t1          # t2 = t0 & t1 // 0x114 & 0xffff ffff => 0x114
    addi    t3, zero, 0x114     # t3 = 0x114
    bne     t2, t3, and_error
    addi    t1, zero, 0x247     # t1 = 0x247
    and     t2, t0, t1          # t2 = t0 & t1 // 0x114 & 0x247 => 0x4
    addi    t3, zero, 0x4       # t3 = 0x4
    beq     t2, t3, and_ok
.and_error:
    addi    a0, zero, 0x10
    jal     error
.and_ok:

    addi    t0, zero, 0x0       # t0 = 0x0
    andi    t2, t0, 0x0         # t2 = t0 & 0x0 // 0x0 & 0x0 => 0x0
    addi    t3, zero, 0x0       # t3 = 0x0
    bne     t2, t3, andi_error
    andi    t2, t0, 0xfff       # t2 = t0 & 0xffff ffff // 0x0 & 0xffff ffff => 0x0
    bne     t2, t3, andi_error
    addi    t0, zero, 0x115     # t0 = 0x115
    andi    t2, t0, 0xfff       # t2 = t0 & 0xffff ffff // 0x115 & 0xffff ffff => 0x115
    addi    t3, zero, 0x115     # t3 = 0x115
    bne     t2, t3, andi_error
    andi    t2, t0, 0x264       # t2 = t0 & 0x264 // 0x115 & 0x264 => 0x4
    addi    t3, zero, 0x4       # t3 = 0x4
    beq     t2, t3, andi_ok
.andi_error:
    addi    a0, zero, 0x11
    jal     error
.andi_ok:

    addi    t0, zero, 0x0       # t0 = 0x0
    addi    t1, zero, 0x0       # t1 = 0x0
    xor     t2, t0, t1          # t2 = t0 ^ t1 // 0x0 ^ 0x0 => 0x0
    addi    t3, zero, 0x0       # t3 = 0x0
    bne     t2, t3, xor_error
    addi    t1, zero, 0x1       # t1 = 0x1
    xor     t2, t0, t1          # t2 = t0 ^ t1 // 0x0 ^ 0x1 => 0x1
    addi    t3, zero, 0x1       # t3 = 0x1
    bne     t2, t3, xor_error
    addi    t0, zero, 0x1       # t0 = 0x1
    xor     t2, t0, t1          # t2 = t0 ^ t1 // 0x1 ^ 0x1 => 0x0
    addi    t3, zero, 0x0       # t3 = 0x0
    bne     t2, t3, xor_error
    addi    t1, zero, 0x2       # t1 = 0x2
    xor     t2, t0, t1          # t2 = t0 ^ t1 // 0x1 ^ 0x2 => 0x3
    addi    t3, zero, 0x3       # t3 = 0x3
    bne     t2, t3, xor_error
    addi    t0, zero, 0x7f      # t0 = 0x7f
    xor     t2, t0, t1          # t2 = t0 ^ t1 // 0x7f ^ 0x2 => 0x7d
    addi    t3, zero, 0x7d      # t3 = 0x7d
    beq     t2, t3, xor_ok
.xor_error:
    addi    a0, zero, 0x12
    jal     error
.xor_ok:

    addi    t0, zero, 0x0       # t0 = 0x0
    xori    t2, t0, 0x0         # t2 = t0 ^ 0x0 // 0x0 ^ 0x0 => 0x0
    addi    t3, zero, 0x0       # t3 = 0x0
    bne     t2, t3, xori_error
    xori    t2, t0, 0x2         # t2 = t0 ^ 0x2 // 0x0 ^ 0x2 => 0x2
    addi    t3, zero, 0x2       # t3 = 0x2
    bne     t2, t3, xori_error
    addi    t0, zero, 0x2       # t0 = 0x2
    xori    t2, t0, 0x2         # t2 = t0 ^ 0x2 // 0x2 ^ 0x2 => 0x0
    addi    t3, zero, 0x0       # t3 = 0x0
    bne     t2, t3, xori_error
    addi    t0, zero, 0x38c     # t0 = 0x38c
    xori    t2, t0, 0x77f       # t2 = t0 ^ 0x77f // 0x38c ^ 0x77f => 0x4f3
    addi    t3, zero, 0x4f3     # t3 = 0x4f3
    beq     t2, t3, xori_ok
.xori_error:
    addi    a0, zero, 0x13
    jal     error
.xori_ok:

    addi    t0, zero, 0x0       # t0 = 0x0
    addi    t1, zero, 0x0       # t1 = 0x0
    blt     t0, t1, blt_error   # if 0x0 < 0x0
    addi    t1, zero, 0xfff     # t1 = 0xffff ffff => -1
    blt     t1, t1, blt_error   # if -1 < -1
    blt     t0, t1, blt_error   # if 0x0 < -1
    addi    t0, zero, 0xffe     # t0 = 0xffff fffe => -2
    blt     t1, t0, blt_error   # if -1 < -2
    addi    t0, zero, 0x7f      # t0 = 0x7f
    blt     t0, t0, blt_error   # if 0x7f < 0x7f
    blt     t0, t1, blt_error   # if 0x7f < -1
    addi    t1, zero, 0x0       # t1 = 0x0
    blt     t0, t1, blt_error   # if 0x7f < 0x0
    addi    t1, zero, 0x40a     # t1 = 0x40a
    blt     t0, t1, blt_ok      # if 0x7f < 0x40a
.blt_error:
    addi    a0, zero, 0x19
    jal     error
.blt_ok:

    addi    t0, zero, 0x0       # t0 = 0x0
    addi    t1, zero, 0x0       # t1 = 0x0
    bge     t0, t1, bge_0_equ   # if 0x0 >= 0x0
    jal     bge_error
.bge_0_equ:
    addi    t1, zero, 0xa       # t1 = 0xa
    bge     t0, t1, bge_error   # if 0x0 >= 0xa
    addi    t1, zero, 0xffe     # t1 = 0xffff fffe => -2
    bge     t1, t0, bge_error   # if -2 >= 0x0
    addi    t0, zero, 0xffe     # t0 = 0xffff fffe => -2
    bge     t0, t1, bge_neg_equ # if -2 >= -2
    jal     bge_error
.bge_neg_equ:
    addi    t1, zero, 0xfff     # t1 = -1
    bge     t0, t1, bge_error   # if -2 >= -1
    addi    t1, zero, 0xe       # t1 = 0xe
    bge     t0, t1, bge_error   # if -2 >= 0xe
    addi    t0, zero, 0xe       # t0 = 0xe
    bge     t0, t1, bge_pos_equ # if 0xe >= 0xe
    jal     bge_error
.bge_pos_equ:
    addi    t1, zero, 0x8       # t1 = 0x8
    bge     t0, t1, bge_ok      # if 0xe >= 0x8
.bge_error:
    addi    a0, zero, 0x1a
    jal     error
.bge_ok:

    addi    t0, zero, 0x0       # t0 = 0x0
    addi    t1, zero, 0x0       # t1 = 0x0
    bltu    t0, t1, bltu_error  # if 0x0 < 0x0
    addi    t0, zero, 0xfff     # t0 = 0xffff ffff
    bltu    t0, t1, bltu_error  # if 0xffff ffff < 0x0
    addi    t1, zero, 0x7ff     # t1 = 0x7ff
    bltu    t0, t1, bltu_error  # if 0xffff ffff < 0x7ff
    addi    t0, zero, 0x1       # t0 = 0x1
    bltu    t0, t1, bltu_ok     # if 0x1 < 0x7ff
.bltu_error:
    addi    a0, zero, 0x1b
    jal     error
.bltu_ok:

    addi    t0, zero, 0x0       # t0 = 0x0
    addi    t1, zero, 0x0       # t1 = 0x0
    bgeu    t0, t1, bgeu_0_equ  # if 0x0 >= 0x0
    jal     bgeu_error
.bgeu_0_equ:
    addi    t1, zero, 0xfff     # t1 = 0xffff ffff
    bgeu    t0, t1, bgeu_error  # if 0x0 >= 0xffff ffff
    addi    t0, zero, 0xfff     # t0 = 0xffff ffff
    bgeu    t0, t1, bgeu_pos_equ# if 0xffff ffff >= 0xffff ffff
    jal     bgeu_error
.bgeu_pos_equ:
    addi    t0, zero, 0x7f      # t0 = 0x7f
    bgeu    t0, t1, bgeu_error  # if 0x7f >= 0xffff ffff
    addi    t1, zero, 0x10      # t1 = 0x10
    bgeu    t0, t1, bgeu_ok     # if 0x7f >= 0x10
.bgeu_error:
    addi    a0, zero, 0x1c
    jal     error
.bgeu_ok:

    # 
.error:
