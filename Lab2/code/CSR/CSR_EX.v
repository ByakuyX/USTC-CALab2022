`timescale 1ns / 1ps
// 实验要求
    // 补全模块（阶段三�?

module CSR_EX(
    input wire clk, bubbleE, flushE,
    input wire [11:0] CSR_addr_ID,
    input wire [31:0] CSR_zimm_ID,
    input wire CSR_zimm_or_reg_ID,
    input wire CSR_write_en_ID,
    output reg [11:0] CSR_addr_EX,
    output reg [31:0] CSR_zimm_EX,
    output reg CSR_zimm_or_reg_EX,
    output reg CSR_write_en_EX
    );

    // TODO: Complete this module

    /* FIXME: Write your code here... */
    initial 
    begin
        CSR_addr_EX = 12'h0;
        CSR_zimm_EX = 32'h0;
        CSR_zimm_or_reg_EX = 0;
        CSR_write_en_EX = 0;

    end
    
    always@(posedge clk)
        if (!bubbleE) 
        begin
            if (flushE)
            begin
                CSR_addr_EX <= 12'h0;
                CSR_zimm_EX <= 32'h0;
                CSR_zimm_or_reg_EX <= 0;
                CSR_write_en_EX <= 0;
            end
            else
            begin
                CSR_addr_EX <= CSR_addr_ID;
                CSR_zimm_EX <= CSR_zimm_ID;
                CSR_zimm_or_reg_EX <= CSR_zimm_or_reg_ID;
                CSR_write_en_EX <= CSR_write_en_ID;
            end
        end
endmodule
