`include "defines.v"

module mac_unit(
    input               clk,
    input               rst,
    input [`ALU_OP_BUS] alu_opcode_i,
    input [2 : 0]       mac_sel_i,

  	input [`VREG_BUS]   mac_op_v1_i,
  	input [`VREG_BUS]   mac_op_v2_i,
    output [`VREG_BUS]  mac_result_o
);

reg [`VREG_BUS] vreg_bias;
reg [`VREG_BUS] vreg_result;
reg [`VREG_BUS] output_temp;
reg [`VREG_BUS] mul_acc;

assign mac_result_o = output_temp ;

always @(posedge clk) begin
    if( rst == 1'b1) begin
      vreg_bias <= 'h0 ;
      vreg_result <= 'h0 ;
    end
    else begin
      case(alu_opcode_i)
          `ALU_OP_VMAC_LW : begin
            vreg_bias <= mac_op_v1_i ;
          end
          `ALU_OP_VMAC_SW : begin
            output_temp <= vreg_result;
          end
          `ALU_OP_VMAC_EN : begin
                     mul_acc[31:0] <= mac_op_v1_i[31:0]    * mac_op_v2_i [31:0]    +
                                      mac_op_v1_i[63:32]   * mac_op_v2_i [63:32]   +
                                      mac_op_v1_i[95:64]   * mac_op_v2_i [95:64]   +
                                      mac_op_v1_i[127:96]  * mac_op_v2_i [127:96]  +
                                      mac_op_v1_i[159:128] * mac_op_v2_i [159:128] +
                                      mac_op_v1_i[191:160] * mac_op_v2_i [191:160] +
                                      mac_op_v1_i[223:192] * mac_op_v2_i [223:192] +
                                      mac_op_v1_i[255:224] * mac_op_v2_i [255:224] ;
            case(mac_sel_i)
              3'b000: vreg_result[31:0]    <= mul_acc[31:0] + vreg_bias[31:0]    ;
              3'b001: vreg_result[63:32]   <= mul_acc[31:0] + vreg_bias[63:32]   ;
              3'b010: vreg_result[95:64]   <= mul_acc[31:0] + vreg_bias[95:64]   ;
              3'b011: vreg_result[127:96]  <= mul_acc[31:0] + vreg_bias[127:96]  ;
              3'b100: vreg_result[159:128] <= mul_acc[31:0] + vreg_bias[159:128] ;
              3'b101: vreg_result[191:160] <= mul_acc[31:0] + vreg_bias[191:160] ;
              3'b110: vreg_result[223:192] <= mul_acc[31:0] + vreg_bias[223:192] ;
              3'b111: vreg_result[255:224] <= mul_acc[31:0] + vreg_bias[255:224] ;
            endcase
          end
            default: begin
              vreg_bias <= 'h0 ;
              vreg_result <= 'h0 ;
            end

      endcase
    end
end




endmodule