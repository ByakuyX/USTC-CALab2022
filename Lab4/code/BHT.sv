`include "CodeFromLab3/CodeFromLab2/Parameters.v"   
module BHT (
    input clk, rst,
    input [31:0] PC_IF, PC_EX,
    input br,
    input [6:0] opE,
    output pr_bht
);
    wire [7:0] tagIF, tagEX;
    assign tagIF = PC_IF[9:2];
    assign tagEX = PC_EX[9:2];

    reg [1:0] prBht[256];

    /***预测结果***/
    assign pr_bht = prBht[tagIF][1];

    /***更新Buffer***/
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            for(integer i = 0; i < 256; i++) begin
                prBht[i] <= 2'b01;
            end
        end
        else begin
            if(opE == `B_TYPE) begin
                if(br) begin
                    prBht[tagEX] <= (prBht[tagEX] == 2'b11) ? 2'b11 : prBht[tagEX] + 2'b01;
                end
                else begin
                    prBht[tagEX] <= (prBht[tagEX] == 2'b00) ? 2'b00 : prBht[tagEX] - 2'b01;
                end
            end
        end
    end
endmodule