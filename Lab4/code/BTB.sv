`include "CodeFromLab3/CodeFromLab2/Parameters.v"   
module BTB (
    input clk, rst,
    input [31:0] PC_IF, PC_EX,
    input br,
    input [6:0] opE,
    input [31:0] br_target,
    output reg [31:0] pr_target,
    output reg pr_en,
    output reg pr_btb
);
    reg [31:0] prTag[64];
    reg [31:0] prTarget[64];
    reg prValid[64];
    reg prBtb[64];
    reg [5:0] pointer;
    
    /***预测结果***/
    always @(*) begin
        if(rst) begin
            pr_target = 0;
            pr_en = 0;
            pr_btb = 0;
        end
        else begin
            pr_target = 0;
            pr_en = 0;
            pr_btb = 0;
            for(integer i = 0; i < 64; i++) begin
                if(PC_IF == prTag[i] && prValid[i]) begin
                    pr_target = prTarget[i];
                    pr_en = 1;
                    pr_btb = prBtb[i];
                    break;
                end
            end
        end
    end

    /***更新Buffer***/
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            for(integer i = 0; i < 64; i++) begin
                prTag[i] <= 0;
                prTarget[i] <= 0;
                prValid[i] <= 0;
                prBtb[i] <= 0;
            end
            pointer <= 0;
        end
        else begin
            if(opE == `B_TYPE) begin
                integer i;
                for(i = 0; i < 64; i++) begin
                    if(PC_EX == prTag[i]) begin
                        prBtb[i] <= br;
                        break;
                    end
                end
                if(i == 64 && br) begin
                    prTag[pointer] <= PC_EX;
                    prTarget[pointer] <= br_target;
                    prValid[pointer] <= 1;
                    prBtb[pointer] <= 1;
                    pointer <= pointer + 1;
                end
            end
        end
    end
endmodule