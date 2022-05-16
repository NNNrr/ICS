`include "defines.v"

module vexe_stage(
    input                   rst,
    input [`ALU_OP_BUS]     alu_opcode_i,
    input [`VREG_BUS]       operand_vs1_i,
    input [`VREG_BUS]       operand_vs2_i,

    output reg [`VREG_BUS]  vexe_result_o
);

always @(*) begin
    if( rst == 1'b1) begin
        vexe_result_o = 0;
    end
    else begin
        case(alu_opcode_i)
        `ALU_OP_VADD: begin
            vexe_result_o [31:0] = operand_vs1_i [31:0] + operand_vs2_i [31:0] ;
            vexe_result_o [63:32] = operand_vs1_i [63:32] + operand_vs2_i [63:32] ;
            vexe_result_o [95:64] = operand_vs1_i [95:64] + operand_vs2_i [95:64] ;
            vexe_result_o [127:96] = operand_vs1_i [127:96] + operand_vs2_i [127:96] ;
            vexe_result_o [159:128] = operand_vs1_i [159:128] + operand_vs2_i [159:128] ;
            vexe_result_o [191:160] = operand_vs1_i [191:160] + operand_vs2_i [191:160] ;
            vexe_result_o [223:192] = operand_vs1_i [223:192] + operand_vs2_i [223:192] ;
            vexe_result_o [255:224] = operand_vs1_i [255:224] + operand_vs2_i [255:224] ;
        end
        `ALU_OP_VMUL: begin
            vexe_result_o [31:0] = operand_vs1_i [31:0] * operand_vs2_i [31:0] ;
            vexe_result_o [63:32] = operand_vs1_i [63:32] * operand_vs2_i [63:32] ;
            vexe_result_o [95:64] = operand_vs1_i [95:64] * operand_vs2_i [95:64] ;
            vexe_result_o [127:96] = operand_vs1_i [127:96] * operand_vs2_i [127:96] ;
            vexe_result_o [159:128] = operand_vs1_i [159:128] * operand_vs2_i [159:128] ;
            vexe_result_o [191:160] = operand_vs1_i [191:160] * operand_vs2_i [191:160] ;
            vexe_result_o [223:192] = operand_vs1_i [223:192] * operand_vs2_i [223:192] ;
            vexe_result_o [255:224] = operand_vs1_i [255:224] * operand_vs2_i [255:224] ;
        end
        default: begin
            vexe_result_o = 0;
        end
        endcase
    end
end

endmodule