
addi    x6,     x2,     0   ; addr_B = B_baseaddr
addi    x7,     x3,     0   ; addr_C = C_baseaddr
addi    x8,     x4,     0   ; addr_D = D_baseaddr

addi    x9,     zero,   8    

addi    x10,    zero,   0   

addi    x5,      x1,    0   ; addr_A = A_baseaddr


addi    x11,    zero,   0

addi    x12,    zero,   0

addi    x15,    x6,     0   ; addr_B = reg[x6]

lw      x13,    0(x5)       ; load data_A
lw      x14,    0(x15)      ; load data_B
mul     x16,    x13,    x14 ; reg[x16] = data_A * data_B
add     x17,    x17,    x16 ; accumulation result put here: reg[x17]    

addi    x5,     x5,     4   ; addr_A = addr_A + 4
addi    x15,    x15,    4   ; addr_B = addr_B + 4
                                
addi    x12,    x12,    1   
bne     x12,    x9 ,    -36 

lw      x18,    0(x7)
add     x17,    x18,    x17 ; reg[17] = row(A)*col(B) + C
sw      x17,    0(x8)       ; save x17 into mem[x8] 
addi    x17,    zero,   0 
addi    x7,     x7,     4
addi    x8,     x8,     4
                 
addi    x11,    x11,    1   
bne     x11,    x9 ,    -72

addi    x6,     x6,     32   ; reg[x5] = reg[x5] + 32 // col + 1

addi    x10,    x10,    1   
bne     x10,    x9 ,    -92