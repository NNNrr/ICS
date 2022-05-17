addi    x5,     x1,     0   ; addr_A = A_baseaddr
addi    x6,     x2,     0   ; addr_B = B_baseaddr
addi    x7,     x3,     0   ; addr_C = C_baseaddr
addi    x8,     x4,     0   ; addr_D = D_baseaddr
addi    x9,     zero,   7
addi    x10,    zero,   0
addi    x11,    zero,   0
addi    x12,    zero,   0

addi    x13,    x5,     0
addi    x14,    x8,     4
addi    x15,    x8,     32

vle32.v vx2,    x13,    1
vle32.v vx3,    x6,     1
vmul.vv vx4,    vx2,    vx3,    0


vse32.v vx4,    x8,     1
vle32.v vx1,    x14,    1
vse32.v vx1,    x15,    1

;vse32.v vx1,    x14,    1
;vle32.v vx5,    x15,    1

;vadd.vv vx1,    vx1,    vx5,    0

;addi    x14,    x14,    4
;addi    x12,    x12,    1
;bne     x12,    x9,     -24

;vse32.v vx1,    x8,     1