addi    x5,     x1,     0   ; addr_A = A_baseaddr
addi    x6,     x2,     0   ; addr_B = B_baseaddr
addi    x7,     x3,     0   ; addr_C = C_baseaddr
addi    x8,     x4,     0   ; addr_D = D_baseaddr

addi    x9,     zero,   8
addi    x13,    x8,     256
addi    x16,    zero,   0

addi    x10,    zero,   0
addi    x11,    zero,   0
addi    x12,    x5,     0    
vle32.v vx3,    x6,     1           ; vx3 = mem[addr_B]

vle32.v vx2,    x12,     1           ; vx2 = mem[addr_A]
vmul.vv vx4,    vx3,    vx2,    0   ; vx4 = vx2 * vx3

vse32.v vx4,    x13,     1           ; mem[addr_D] = vx1

lw      x14,    0(x13)
;add     x15,    x15,    x14
;addi    x13,    x13,    4
;addi    x16,    x16,    1
;bne     x16,    x9,     -20

;addi    x13,    x8,     256
sw      x14,    0(x8)
;addi    x8,     x8,     4

;addi    x12,    x12,    32
;addi    x11,    x11,    1
;bne     x11,    x9,     -52

;addi    x6,     x6,     32

;addi    x10,    x10,    1
;bne     x10,    x9,     -76




