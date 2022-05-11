`timescale 1ns / 1ps
module pe #(
    parameter N = 8,
    parameter MAX_CNT = 8,
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH = 16
)(
    input clk,
    input rst,
    input init,
    input [DATA_WIDTH-1:0] in_a,
    input [DATA_WIDTH-1:0] in_b,
    output reg [DATA_WIDTH-1:0] out_a,
    output reg [DATA_WIDTH-1:0] out_b,
    output [ACC_WIDTH-1:0] out_sum,
    output valid_D
);

    wire[ACC_WIDTH-1:0] mult;
    reg[ACC_WIDTH-1:0] out_tmp;
    reg[31:0] cnt,m_cnt;

    assign mult = in_a * in_b;


    assign out_sum = out_tmp;

always @(posedge clk or posedge rst)    //将输入数据存入寄存器中，并传递给相邻PE
begin
    if(rst)
        begin
            out_a <= 'b0;
            out_b <= 'b0;
        end
    else if(init)
        begin
            out_a <= 'b0;
            out_b <= 'b0;
        end
    else
        begin
            out_a <= in_a;
            out_b <= in_b;
        end
end

always @(posedge clk or posedge rst)    //将输入数据相乘后累加，并输出
begin
    if(rst)
        out_tmp <= 'b0;
    else if(init)
        out_tmp <= 'b00;
    else
        out_tmp <= out_tmp + mult;
end

always @(posedge clk or posedge rst)    //根据两个矩阵大小，确定计算一个输出结果的时钟周期，以及完成两个矩阵乘法所需最多周期数
begin
    if(rst)
        begin
            cnt <= 'b0;
            m_cnt <= 'b0;
        end
    else if(init) 
        begin
            cnt <= 'b0;
            m_cnt <= 'b0;
        end
    else if (m_cnt < MAX_CNT)
        begin
            if(cnt == N)
                begin
                    cnt <= 'b0;
                    m_cnt <= m_cnt + 1;
                end
            else
                begin
                    cnt <= cnt + 1;
                    m_cnt <= m_cnt;
                end
        end
end

assign valid_D = (cnt == N);        //完成两个向量乘积计算后告知计算结果有效，维持一个时钟周期

endmodule
