`include "CodeFromLab3/CodeFromLab2/Parameters.v"   
module BrPredict # (
    parameter Predict_en = `BHT
) (
    input clk, rst,
    input [31:0] PC_IF, PC_EX,
    input br, prE,
    input [6:0] opE,
    input [31:0] br_target,
    output [31:0] pr_target,
    output reg pr
);
    wire pr_en, pr_btb, pr_bht;

    BTB BTB1 (
        .clk(clk),
        .rst(rst),
        .PC_IF(PC_IF),
        .PC_EX(PC_EX),
        .br(br),
        .opE(opE),
        .br_target(br_target),
        .pr_target(pr_target),
        .pr_en(pr_en),
        .pr_btb(pr_btb)
    );

    BHT BHT1 (
        .clk(clk),
        .rst(rst),
        .PC_IF(PC_IF),
        .PC_EX(PC_EX),
        .br(br),
        .opE(opE),
        .pr_bht(pr_bht)
    );

    always @(*)
    begin
        if(Predict_en == `BTB)
            pr = pr_en & pr_btb;
        else if(Predict_en == `BHT)
            pr = pr_en & pr_bht;
        else
            pr = 0;
    end
    
    //预测错误次数统计
    reg [31:0] PrWrCnt;
    reg [31:0] BrCnt;
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            PrWrCnt <= 0;
            BrCnt <= 0;
        end
        else if(opE == `B_TYPE) begin
            BrCnt <= BrCnt + 1;
            if((br && ~prE) || (~br && prE))
                PrWrCnt <= PrWrCnt + 1;
        end
    end
endmodule