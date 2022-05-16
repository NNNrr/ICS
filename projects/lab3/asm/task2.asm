addi    x5,     x1,     0   ; addr_A = A_baseaddr
addi    x6,     x2,     0   ; addr_B = B_baseaddr
addi    x7,     x3,     0   ; addr_C = C_baseaddr
addi    x8,     x4,     0   ; addr_D = D_baseaddr

addi    x9,     x8,     256
addi    x12,    zero,   8
addi    x13,    zero,   0
vle32.v vx2,    x5,     1           ; vx2 = mem[addr_A]
vle32.v vx3,    x6,     1           ; vx3 = mem[addr_B]
vle32.v vx5 ,   x7,     1

vmul.vv vx4,    vx3,    vx2,    0   ; vx4 = vx2 * vx3

vse32.v vx4,    x9,     1           ; mem[addr_D] = vx1

lw      x10,    0(x9)
add     x11,    x11,    x10

addi    x9,     x9,     4
addi    x13,    x13,    1
bne     x13,    x12,    -20    
lw      x14,    0(x7)
add     x11,    x11,    x14
;sw      x11,    0(x8)  





