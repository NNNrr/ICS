`timescale 1ns / 1ps
module im2col #(
    parameter IMG_W = 8,
    parameter IMG_H = 8,
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 32,
    parameter FILTER_SIZE = 3,
    parameter IMG_BASE = 16'h0000,
    parameter IM2COL_BASE = 16'h2000
) (
    input clk,
    input rst_im2col,
    input [DATA_WIDTH-1:0] data_rd,
    output [DATA_WIDTH-1:0] data_wr,
    output [ADDR_WIDTH-1:0] addr_wr,
    output [ADDR_WIDTH-1:0] addr_rd,
    output reg im2col_done,
    output reg mem_wr_en
);

parameter IMG_NUM = IMG_H * IMG_W ;
parameter IM2COL_NUM = IMG_NUM*FILTER_SIZE*FILTER_SIZE; //输出数据的总数


reg[ADDR_WIDTH-1:0] im2col_row,im2col_col;
reg[ADDR_WIDTH-1:0] rd_cnt,wr_cnt,coor_cnt;
reg[DATA_WIDTH-1:0] data_rd_reg [IMG_NUM:0];
reg[DATA_WIDTH-1:0] data_wr_reg;
reg[3:0] im2col_cnt;

wire wr_flag;


assign wr_flag = rd_cnt == IMG_NUM ;

integer i;

assign addr_rd = IMG_BASE + rd_cnt;
assign addr_wr = IM2COL_BASE + wr_cnt - 1;
assign data_wr = data_wr_reg;

always @(posedge clk or posedge rst_im2col)   //读操作地址计数器
begin
    if(rst_im2col)
        rd_cnt <= 'd0;
    else if(rd_cnt < IMG_NUM)
        rd_cnt <= rd_cnt + 1'b1;
    else
        rd_cnt <= rd_cnt;
end

always @(posedge clk or posedge rst_im2col)   //读操作，将输入数据存入寄存器变量中
begin
    if(rst_im2col)
        begin
            for(i=0;i<IMG_NUM + 1;i = i + 1'b1)
                data_rd_reg[i] <= 'd0;
        end
    else if(!mem_wr_en)
        begin
            data_rd_reg[rd_cnt] <= data_rd;
        end
end

always @(posedge clk or posedge rst_im2col)  //窗口计数器，每个filter的大小为3*3
begin
    if(rst_im2col)
        im2col_cnt <= 'd0;
    else if(mem_wr_en)
        begin
            if(im2col_cnt == 4'd8)
                im2col_cnt <= 4'd0;
            else
                im2col_cnt <= im2col_cnt + 1'b1;
        end
    else
        im2col_cnt <= im2col_cnt;
end

always @(posedge clk or posedge rst_im2col)  //写计数器，总共需要的写操作次数
begin
    if(rst_im2col)
        wr_cnt <= 'd0;
    else if(mem_wr_en && wr_cnt < IM2COL_NUM)
        wr_cnt <= wr_cnt + 1'b1;
    else
        wr_cnt <= wr_cnt;
end

always @(posedge clk or posedge rst_im2col)  //坐标计数器，定位正在进行im2col操作的窗口中心坐标
begin
    if(rst_im2col)
        begin
            im2col_row <= 'd0;
            im2col_col <= 'd0;
        end
    else if(mem_wr_en)
        begin
            if((im2col_row == IMG_H - 1) && (im2col_col == IMG_W - 1))
                begin
                    im2col_row <= im2col_row;
                    im2col_col <= im2col_col;
                end
            else
                begin
                    if(im2col_cnt == 4'd8)
                        begin
                            if(im2col_col == IMG_W - 1)
                                begin
                                    im2col_row <= im2col_row + 1'b1;
                                    im2col_col <= 'd0; 
                                end
                            else
                                begin
                                    im2col_row <= im2col_row;
                                    im2col_col <= im2col_col + 1'b1; 
                                end
                        end
                    else
                        begin
                            im2col_row <= im2col_row;
                            im2col_col <= im2col_col;
                        end
                end
        end
end

always @(posedge clk or posedge rst_im2col)  //输出坐标计数，用于定位输出数据对应到输入暂存寄存器的位置
begin
    if(rst_im2col)
        coor_cnt <= 'b1;
    else if(mem_wr_en && im2col_cnt == 4'd8)
        coor_cnt <= coor_cnt + 1'b1;
    else
        coor_cnt <= coor_cnt;
end

always @(posedge clk or posedge rst_im2col)  //写操作使能
begin
    if(rst_im2col)
        mem_wr_en <= 1'b0;
    else if(wr_cnt == IM2COL_NUM)
        mem_wr_en <= 1'd0;
    else if(wr_flag)
        mem_wr_en <= 1'b1;
    else 
        mem_wr_en <= 1'b0;
end

always @(posedge clk or posedge rst_im2col)  //根据中心位置坐标定位每个窗口中对应位置数据的地址
begin
    if(rst_im2col)
        begin
            data_wr_reg <= 'b0;
        end
    else if(mem_wr_en)
        begin
            case(im2col_cnt)
                4'd0:begin
                    if(im2col_row == 'd0| im2col_col == 'd0)
                        data_wr_reg <= 'd0;
                    else
                        data_wr_reg <= data_rd_reg[coor_cnt - IMG_W - 1];
                end
                4'd1:begin
                    if(im2col_row == 'd0)
                        data_wr_reg <= 'd0;
                    else
                        data_wr_reg <= data_rd_reg[coor_cnt - IMG_W];
                end
                4'd2:begin
                    if(im2col_row == 'd0 | (im2col_col == IMG_W - 1))
                        data_wr_reg <= 'd0;
                    else
                        data_wr_reg <= data_rd_reg[coor_cnt - IMG_W + 1];
                end
                4'd3:begin
                    if( im2col_col == 'd0)
                        data_wr_reg <= 'd0;
                    else
                        data_wr_reg <= data_rd_reg[coor_cnt - 1];
                end
                4'd4:begin
                        data_wr_reg <= data_rd_reg[coor_cnt];
                end
                4'd5:begin
                    if( im2col_col == IMG_W - 1)
                        data_wr_reg <= 'd0;
                    else
                        data_wr_reg <= data_rd_reg[coor_cnt + 1];
                end
                4'd6:begin
                    if( (im2col_row == IMG_H -1) | im2col_col == 'd0)
                        data_wr_reg <= 'd0;
                    else
                        data_wr_reg <= data_rd_reg[coor_cnt + IMG_W - 1];
                end
                4'd7:begin
                    if( im2col_row == IMG_H -1)
                        data_wr_reg <= 'd0;
                    else
                        data_wr_reg <= data_rd_reg[coor_cnt + IMG_W];
                end
                4'd8:begin
                    if( im2col_col == IMG_W -1 | im2col_row == IMG_H -1)
                        data_wr_reg <= 'd0;
                    else
                        data_wr_reg <= data_rd_reg[coor_cnt + IMG_W + 1];
                end
            default:data_wr_reg <= 'd0;
            endcase
        end
end

always @(posedge clk or posedge rst_im2col)  //操作完成信号
begin
    if(rst_im2col)
        im2col_done <= 1'd0;
    else if(wr_cnt == IM2COL_NUM)
        im2col_done <= 1'd1;
    else
        im2col_done <= 1'd0;
end

endmodule