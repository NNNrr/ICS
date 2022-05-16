addi    x5,     x1,     0   ; addr_A = A_baseaddr
addi    x6,     x2,     0   ; addr_B = B_baseaddr
addi    x7,     x3,     0   ; addr_C = C_baseaddr
addi    x8,     x4,     0   ; addr_D = D_baseaddr

vle32.v vx2,    x5,     1           ; vx2 = mem[addr_A]
vle32.v vx3,    x6,     1           ; vx3 = mem[addr_B]

vmul.vv vx4,    vx2,    vx3,    0   ; vx4 = vx2 * vx3
vadd.vv vx1,    vx2,    vx3,    0   ; vx1 = vx1 + vx4

vse32.v vx1,    x8,     1           ; mem[addr_D] = vx1

