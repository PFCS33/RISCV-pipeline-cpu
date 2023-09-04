.data
	#.word 0x12345

.text
    bne     zero, zero, error
    beq     zero, zero, beq_temp_ok
    jal     error
.beq_temp_ok:
    ori     t0, zero, 0xfff     ; t0 = 0xffff ffff
    beq     t0, zero, error
    bne     t0, zero, ori_temp_ok
    jal     error
.ori_temp_ok:
    ori     t0, zero, 0x0       ; t0 = 0x0
    bne     t0, zero, error
    beq     t0, zero, bne_temp_ok
    jal     error
.bne_temp_ok_ok:

;

    ori     t0, zero, 0xfff     ; t0 = 0xffff ffff
    ori     t1, zero, 0x1       ; t1 = 0x1
    add     t2, t0, t1          ; t2 = 0xffff ffff + 0x1 // 0x0
    bne     t2, zero, add_error
    ori     t1, zero, 0x2       ; t1 = 0x2
    add     t2, t0, t1          ; t2 = 0xffff ffff + 0x2 // 0x1
    ori     t3, zero, 0x1       ; t3 = 0x1
    bne     t2, t3, add_error
	ori     t0, zero, 0x300     ; t0 = 0x300
	ori     t1, zero, 0x55      ; t1 = 0x55
	add     t2, t0, t1          ; t2 = t0 + t1 // 0x355
	ori     t3, t3, 0x355       ; t3 = 0x355
    beq     t2, t3, add_ok
.add_error:
    ori     a0, zero, 0x2
    jal     error
.add_ok:

    ori     t0, zero, 0x0       ; t0 = 0x0
    ori     t1, zero, 0x1       ; t1 = 0x1
    sub     t2, t0, t1          ; t2 = t0 - t1 // 0xffff ffff
    ori     t3, zero, 0xfff     ; t3 = 0xffff ffff
    bne     t2, t3, sub_error
	ori     t0, zero, 0x300     ; t0 = 0x300
	ori     t1, zero, 0x55      ; t1 = 0x55
    sub     t2, t0, t1          ; t2 = t0 - t1 //0x2ab
    ori     t3, zero, 0x2ab     ; t3 = 0x2ab
    beq     t2, t3, sub_ok
.sub_error:
    ori     a0, zero, 0x3
    jal     error
.sub_ok:

    ori     t0, zero, 0xfff     ; t0 = 0xffff ffff
    addi    t2, t0, 0x1         ; t2 = t0 + 0x1 // 0x0
    bne     t2, zero, addi_error
    addi    t2, t0, 0x2         ; t2 = t0 + 0x2 // 0x1
    ori     t3, zero, 0x1       ; t3 = 0x1
    bne     t2, t3, addi_error
	ori     t0, zero, 0x300     ; t0 = 0x300
    addi    t2, t0, 0x54        ; t2 = t0 + 0x54 //0x354
    ori     t3, zero, 0x354     ; t3 = 0x354
    beq     t2, t3, addi_ok
.addi_error:
    ori     a0, zero, 0x4
    jal     error
.addi_ok:

;

	addi    t0, zero, 0x300     ; t0 = 0x300
    addi    t1, zero, 0x9       ; t1 = 0x9
    srl     t2, t0, t1          ; t2 = t0 >>l t1[4:0] // 0x300 >>l 0x9 => 0x1
    addi    t3, zero, 0x1       ; t3 = 0x1
    bne     t2, t3, srl_error
    addi    t1, zero, 0xf28     ; t1 = 0xffff ff28
    srl     t2, t0, t1          ; t2 = t0 >>l t1[4:0] // 0x300 >>l 0x8 => 0x3
    addi    t3, zero, 0x3       ; t3 = 0x3
    bne     t2, t3, srl_error
    addi    t0, zero, 0x800     ; t0 = 0xffff f800
    addi    t1, zero, 0xf38     ; t1 = 0xffff ff38
    srl     t2, t0, t1          ; t2 = t0 >>l t1[4:0] // 0xffff f800 >>l 0x18 => 0xff
    addi    t3, zero, 0xff      ; t3 = 0xff
    beq     t2, t3, srl_ok
.srl_error:
    addi    a0, zero, 0x8
    jal     error
.srl_ok:

    addi    t0, zero, 0xa       ; t0 = 0xa
    addi    t1, zero, 0xf61     ; t1 = 0xffff ff61
    sra     t2, t0, t1          ; t2 = t0 >>a t1[4:0] // 0xa >>a 0x1 => 0x5
    addi    t3, zero, 0x5       ; t3 = 0x5
    bne     t2, t3, sra_error
    addi    t0, zero, 0x801     ; t0 = 0xffff f801
    addi    t1, zero, 0x8
    sra     t2, t0, t1          ; t2 = t0 >>a t1[4:0] // 0xffff f801 >>a 0x8 => 0xffff fff8
    addi    t3, zero, 0xff8     ; t3 = 0xffff fff8
    beq     t2, t3, sra_ok
.sra_error:
    addi    a0, zero, 0x7
    jal     error
.sra_ok:

    addi    t0, zero, 0xf00     ; t0 = 0xffff ff00
    addi    t1, zero, 0x18      ; t1 = 0x18
    sll     t2, t0, t1          ; t2 = t0 <<l t1 // 0xffff ff00 <<l 0x18 => 0x0
    addi    t3, zero, 0x0       ; t3 = 0x0
    bne     t2, t3, sll_error
    addi    t1, zero, 0x4       ; t1 = 0x4
    sll     t2, t0, t1          ; t2 = t0 <<l t1 // 0xffff ff00 <<l 0x4 => 0xffff f000
    addi    t3, zero, 0x7ff     ; t3 = 0x7ff
    add     t3, t3, t3          ; t3 = 0xffe
    addi    t3, t3, 0x2         ; t3 = 0x1000
    sub     t3, zero, t3        ; t3 = 0xffff f000
    bne     t2, t3, sll_error
    addi    t0, zero, 0x300     ; t0 = 0x300
    addi    t1, zero, 0x55      ; t1 = 0x55
    sll     t2, t0, t1          ; t2 = t0 <<l t1[4:0] // 0x300 <<l 0x15 => 0x6000 0000
    addi    t4, zero, 0x1c      ; t4 = 0x1c
    sra     t2, t2, t4          ; t2 = t2 >>a t4[4:0] // 0x6000 0000 >>a 0x1c => 0x6
    addi    t3, zero, 0x6       ; t3 = 0x6
    beq     t2, t3, sll_ok
.sll_error:
    addi    a0, zero, 0x5
    jal     error
.sll_ok:

    addi    t0, zero, 0x300     ; t0 = 0x300
    srli    t2, t0, 0x7         ; t2 = t0 >>l 0x7 // 0x300 >>l 0x7 => 0x6
    addi    t3, zero, 0x6       ; t3 = 0x6
    bne     t2, t3, srli_error
    addi    t0, zero, 0x801     ; t0 = 0xffff f801
    srli    t2, t0, 0x1d        ; t2 = t0 >>l 0x1d // 0xffff f801 >>l 0x1d => 0x7
    addi    t3, zero, 0x7       ; t3 = 0x7
    beq     t2, t3, srli_ok
.srli_error:
    addi    a0, zero, 0x9
    jal     error
.srli_ok:

    addi    t0, zero, 0x801     ; t0 = 0xffff f801
    srai    t2, t0, 0x9         ; t2 = t0 >>a 0x9 // 0xffff f801 >>a 0x9 => 0xffff fffc
    addi    t3, zero, 0xffc     ; t3 = 0xffff fffc
    bne     t2, t3, srai_error
    srai    t2, t0, 0x1d        ; t2 = t0 >>a 0x1d // 0xffff f801 >>a 0x1d => 0xffff ffff
    addi    t3, zero, 0xfff     ; t3 = 0xffff ffff
    beq     t2, t3, srai_ok
.srai_error:
    addi    a0, zero, 0xa
    jal     error
.srai_ok:

    addi    t0, zero, 0xf00     ; t0 = 0xffff ff00
    slli    t2, t0, 0x18        ; t2 = t0 <<l 0x18 // 0xffff ff00 <<l 0x18 => 0x0
    addi    t3, zero, 0x0       ; t3 = 0x0
    bne     t2, t3, slli_error
    slli    t2, t0, 0x8         ; t2 = t0 <<l 0x8 // 0xffff ff00 <<l 0x8 => 0xffff 0000
    addi    t3, zero, 0x8       ; t3 = 0x8
    sll     t3, t0, t3          ; t3 = t0 <<l t3 // 0xffff ff00 <<l 0x8 => 0xffff 0000
    bne     t2, t3, slli_error
    slli    t2, t0, 0x16        ; t2 = t0 <<l 0x16 // 0x300 <<l 0x16 => 0xc000 0000
    srai    t2, t2, 0x1d        ; t2 = t2 >>a 0x1d // 0xc000 0000 >>a => 0xffff fffe
    addi    t3, zero, 0xffe     ; t3 = 0xffff fffe
    beq     t2, t3, slli_ok
.slli_error:
    addi    a0, zero, 0x6
    jal     error
; .slli_ok:


.error:
    