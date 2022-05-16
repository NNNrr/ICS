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
            vexe_result_o = operand_vs1_i + operand_vs2_i ;
        end
        `ALU_OP_VMUL: begin
            vexe_result_o = (operand_vs1_i * operand_vs2_i) ;
        end
        default: begin
            vexe_result_o = 0;
        end
        endcase
    end
end

endmodule