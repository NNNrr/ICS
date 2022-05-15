        addi    x30,    zero,  0
        addi    x31,    zero,  63
        addi    x5,     x1,     0   ; addr_A = A_baseaddr
        addi    x6,     x2,     0   ; addr_B = B_baseaddr
        addi    x7,     x3,     0   ; addr_C = C_baseaddr
        addi    x8,     x4,     0   ; addr_D = D_baseaddr
        lw      x9,     0(x5)
        lw      x10,    0(x6)
        mul     x11,    x10,    x9
        lw      x12,    0(x7)
        add     x13,    x12,    x11
        sw      x13,    0(x8)
        addi    x5,     x5,     4
        addi    x6,     x6,     4
        addi    x7,     x7,     4
        addi    x8,     x8,     4
        addi    x30,    x30,    1
        bne     x30,    x31,    -4