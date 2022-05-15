addi    x5,     x1,     0   ; addr_A = A_baseaddr
addi    x6,     x2,     0   ; addr_B = B_baseaddr
addi    x7,     x3,     0   ; addr_C = C_baseaddr
addi    x8,     x4,     0   ; addr_D = D_baseaddr

addi    x9,     zero,   64
addi    x10,    zero,   0

sw      x7,     0(x8)

addi    x7,     x7,     4
addi    x8,     x8,     4

addi    x10,    x10,     1   ; for( index_row=index_row+1 )
bne     x10,    x9,     -20 ; for( index_row<num_size )6