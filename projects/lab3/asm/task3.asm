addi    x5,     x1,     0   ; addr_A = A_baseaddr
addi    x6,     x2,     0   ; addr_B = B_baseaddr
addi    x7,     x3,     0   ; addr_C = C_baseaddr
addi    x8,     x4,     0   ; addr_D = D_baseaddr

;addi    x9,     zero,   8
;addi    x10,    zero,   0

vle32.v vx2,    x5,     1
vle32.v vx3,    x6,     1
vle32.v vx4,    x7,     1
vmac.lw vx4
vmac.en 0,      vx2,    vx3
addi    x5,     x5,     32
vle32.v vx2,    x5,     1
vmac.en 1,      vx2,    vx3
addi    x5,     x5,     32
vle32.v vx2,    x5,     1
vmac.en 2,      vx2,    vx3
addi    x5,     x5,     32
vle32.v vx2,    x5,     1
vmac.en 3,      vx2,    vx3
addi    x5,     x5,     32
vle32.v vx2,    x5,     1
vmac.en 4,      vx2,    vx3
addi    x5,     x5,     32
vle32.v vx2,    x5,     1
vmac.en 5,      vx2,    vx3
addi    x5,     x5,     32
vle32.v vx2,    x5,     1
vmac.en 6,      vx2,    vx3
addi    x5,     x5,     32
vle32.v vx2,    x5,     1
vmac.en 7,      vx2,    vx3
addi    x5,     x5,     32
vle32.v vx2,    x5,     1
vmac.sw vx1
vse32.v vx4,     x8,     1
;addi    x5,     x1,     0   
;addi    x7,     x7,     32
;addi    x8,     x8,     32
;addi    x10,    x10,    1
;bne     x10,    x9,     -136