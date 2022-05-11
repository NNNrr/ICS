`timescale 1ns / 1ps

module systolic #(
    parameter M = 12,
    parameter N = 6,
    parameter K = 8,
    parameter ARR_SIZE = 4,
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH = 16
)(
    input clk,
    input rst,
    input enable_row_count_A,
    input [DATA_WIDTH*ARR_SIZE-1:0] A,
    input [DATA_WIDTH*ARR_SIZE-1:0] B,
    output [ACC_WIDTH*ARR_SIZE*ARR_SIZE-1:0] D,
    output [ARR_SIZE*ARR_SIZE-1:0] valid_D,
    output [31:0] pixel_cntr_A,
    output [31:0] slice_cntr_A,
    output [31:0] pixel_cntr_B,
    output [31:0] slice_cntr_B
);

    parameter MAX_CNT = (M*N)/(ARR_SIZE*ARR_SIZE);
    reg [DATA_WIDTH-1:0] out_a_reg,out_b_reg;
    reg [ACC_WIDTH-1:0] out_tmp[ARR_SIZE*ARR_SIZE-1:0];
    reg [ARR_SIZE*ARR_SIZE-1:0] valid_D_reg;
    reg [ARR_SIZE*ARR_SIZE-1:0] init_reg;

    reg [DATA_WIDTH-1:0] a_reg [ARR_SIZE:0][ARR_SIZE:0];
    reg [DATA_WIDTH-1:0] b_reg [ARR_SIZE:0][ARR_SIZE:0];
    reg [31:0] pixel_counter,total_counter,slice_counter_B,slice_counter_A;

    genvar i,j;
    generate                                                    //根据矩阵大小，实例化ARR_SIZE*ARR_SIZE个PE
        for(i=0;i<ARR_SIZE;i=i+1)
            begin :row
                for(j=0;j<ARR_SIZE;j=j+1)
                    begin :col
                        pe#(
                            .N(N),
                            .MAX_CNT(MAX_CNT),
                            .DATA_WIDTH(DATA_WIDTH),
                            .ACC_WIDTH(ACC_WIDTH)
                        )
                        pixel(
                            .clk(clk),
                            .rst(rst),
                            .init(init_reg[i*ARR_SIZE+j]),
                            .in_a(a_reg[i][j]),
                            .in_b(b_reg[i][j]),
                            .out_a(a_reg[i][j+1]),
                            .out_b(b_reg[i+1][j]),
                            .out_sum(out_tmp[i*ARR_SIZE+j]),
                            .valid_D(valid_D_reg[i*ARR_SIZE+j])
                        );
                    end
            end
    endgenerate

    generate                                                    //读取每个PE的累乘数据
        for(i=0;i<ARR_SIZE*ARR_SIZE;i=i+1)
            begin
                assign D[((i+1)*ACC_WIDTH)-1:i*ACC_WIDTH] = rst?'b0:out_tmp[i];
            end
    endgenerate

    generate                                                    //读取每个PE的累乘数据有效信号
        for(i=0;i<ARR_SIZE*ARR_SIZE;i=i+1)
            begin
                assign valid_D[i] = rst?'b0:valid_D_reg[i];
            end
    endgenerate

    generate                                                    //生成每个PE的清零信号
        for(i=0;i<ARR_SIZE;i=i+1)
            begin
                for(j=0;j<ARR_SIZE;j=j+1)
                    begin
                        assign init_reg[i*ARR_SIZE+j] = ((i + j ) < total_counter)?1'b0:1'b1;
                    end
            end
    endgenerate

    generate                                                    //读取矩阵B的输入pixel
        for(j=0;j<ARR_SIZE;j=j+1)
            begin
                always @(*)
                    begin
                        if(rst)
                            b_reg[0][j] = 'b0;
                        else
                            b_reg[0][j] = B[((j+1)*DATA_WIDTH)-1:j*DATA_WIDTH];
                    end
            end
    endgenerate

    generate                                                    //读取矩阵A的输入pixel
        for(i=0;i<ARR_SIZE;i=i+1)
            begin
                always @(*)
                    begin
                        if(rst)
                            a_reg[i][0] = 'b0;
                        else
                            a_reg[i][0] = A[((i+1)*DATA_WIDTH)-1:i*DATA_WIDTH];
                    end
            end
    endgenerate

    always @(posedge clk or posedge rst)                        //pixel计数器，每个slice的pixel个数为 N + ARR_SIZE
    begin
        if(rst)
            pixel_counter  <= 'b0;
        else if(pixel_counter == (N + ARR_SIZE - 1)  | total_counter == (2*ARR_SIZE + N - 1))
            pixel_counter  <= 'b0;
        else
            pixel_counter  <= pixel_counter + 1'b1;
    end

    always @(posedge clk or posedge rst)                        //OS脉动矩阵一个周期所需的时钟周期
    begin
        if(rst)
            total_counter <= 'b0;
        else if (total_counter == (2*ARR_SIZE + N - 1))
            total_counter <= 'b0;
        else
            total_counter <= total_counter + 1'b1;
    end

    always @(posedge clk or posedge rst)                        //矩阵B的slice计数器
    begin
        if(rst)
            slice_counter_B <= 'b0;
        else if(total_counter == (2*ARR_SIZE + N - 1) && slice_counter_B == (K/ARR_SIZE - 1 ))
            slice_counter_B <= 'b0;
        else if(total_counter == (2*ARR_SIZE + N - 1))
            slice_counter_B <= slice_counter_B + 1'b1;
    end

    always @(posedge clk or posedge rst)                        //矩阵A的slice计数器
    begin
        if(rst)
            slice_counter_A <= 'b0;
        else if(enable_row_count_A && slice_counter_A == (M/ARR_SIZE - 1))
            slice_counter_A <= 'b0;
        else if(enable_row_count_A)
            slice_counter_A <= slice_counter_A + 1'b1 ;
    end

    assign pixel_cntr_A = pixel_counter;
    assign pixel_cntr_B = pixel_counter;
    assign slice_cntr_A = slice_counter_A;
    assign slice_cntr_B = slice_counter_B;

endmodule

