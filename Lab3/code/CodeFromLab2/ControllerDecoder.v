`timescale 1ns / 1ps
//  ĺč˝čŻ´ć
    //  ĺŻšćäť¤čżčĄčŻç ďźĺ°ĺśçżťčŻćć§ĺśäżĄĺˇďźäź čžçťĺä¸Şé¨äť?
// čžĺĽ
    // Inst              ĺžčŻç ćäť?
// čžĺş
    // jal               jalčˇłč˝Źćäť¤
    // jalr              jalrčˇłč˝Źćäť¤
    // op1_src           0čĄ¨ç¤şALUćä˝ć?1ćĽčŞĺŻĺ­ĺ¨ďź1čĄ¨ç¤şćĽčŞPC-4
    // op2_src           ALUççŹŹäşä¸Şćä˝ć°ćĽćşă?ä¸ş1ćśďźop2éćŠimmďźä¸ş0ćśďźop2éćŠreg2
    // ALU_func          ALUć§čĄçčżçŽçąťĺ?
    // br_type           branchçĺ¤ć­ćĄäťśďźĺŻäťĽćŻä¸čżčĄbranch
    // load_npc          ĺĺĺŻĺ­ĺ¨çĺźçćĽćşďźPCćč?ALUčŽĄçŽçťćďź?, load_npc == 1ćśé?ćŠPC
    // wb_select         ĺĺĺŻĺ­ĺ¨çĺźçćĽćşďźCacheĺĺŽšćč?ALUčŽĄçŽçťćďźďźwb_select == 1ćśé?ćŠcacheĺĺŽš
    // load_type         loadçąťĺ
    // reg_write_en      éç¨ĺŻĺ­ĺ¨ĺä˝żč˝ďźreg_write_en == 1čĄ¨ç¤şé?čŚĺĺreg
    // cache_write_en    ćĺ­čĺĺĽdata cache
    // imm_type          ćäť¤ä¸­çŤĺłć°çąťĺ
    // CSR_write_en
    // CSR_zimm_or_reg
// ĺŽéŞčŚćą
    // čĄĽĺ¨ć¨Ąĺ ĺˇ˛ĺŽć?


`include "Parameters.v"   
module ControllerDecoder(
    input wire [31:0] inst,
    output reg jal,
    output reg jalr,
    output reg op1_src, op2_src,
    output reg [3:0] ALU_func,
    output reg [2:0] br_type,
    output reg load_npc,
    output reg wb_select,
    output reg [2:0] load_type,
    output reg reg_write_en,
    output reg [3:0] cache_write_en,
    output reg [2:0] imm_type,
    // CSR signals
    output reg CSR_write_en,
    output reg CSR_zimm_or_reg
    );

    // TODO: Complete this module

    wire [6:0] opcode, funct7;
    wire [2:0] funct3;

    assign opcode = inst[6:0];
    assign funct7 = inst[31:25];
    assign funct3 = inst[14:12];

    always @ (*)
    begin
        if (opcode == `U_LUI)
        begin
            jal = 0;
            jalr = 0;
            op1_src = 0;
            op2_src = 1;
            ALU_func = `LUI;
            br_type = 0;
            load_npc = 0;
            wb_select = 0;
            load_type = 0;
            reg_write_en = 1;
            cache_write_en = 0;
            imm_type = `UTYPE;
            CSR_write_en = 0;
            CSR_zimm_or_reg = 0;
        end
        else if (opcode == `J_JAL)
        begin
            jal = 1;
            jalr = 0;
            op1_src = 0;
            op2_src = 0;
            ALU_func = 0;
            br_type = 0;
            load_npc = 1;
            wb_select = 0;
            load_type = 0;
            reg_write_en = 1;
            cache_write_en = 0;
            imm_type = `JTYPE;
            CSR_write_en = 0;
            CSR_zimm_or_reg = 0;
        end
        else if (opcode == `I_LOAD)
        begin
            jal = 0;
            jalr = 0;
            op1_src = 0;
            op2_src = 1;
            ALU_func = `ADD;
            br_type = 0;
            load_npc = 0;
            wb_select = 1;
            
            reg_write_en = 1;
            cache_write_en = 0;
            imm_type = `ITYPE;
            CSR_write_en = 0;
            CSR_zimm_or_reg = 0;
            if (funct3 == `I_LB)
            begin
                load_type = `LB;
            end
            else if (funct3 == `I_LH)
            begin
                load_type = `LH;
            end
            else if (funct3 == `I_LW)
            begin
                load_type = `LW;
            end
            else if (funct3 == `I_LBU)
            begin
                load_type = `LBU;
            end
            else if (funct3 == `I_LHU)
            begin
                load_type = `LHU;
            end
            else 
            begin
                reg_write_en = 0;
                load_type = `NOREGWRITE;
            end
        end

        /* FIXME: Write your code here... */
        else if (opcode == `U_AUIPC)
        begin
            jal = 0;
            jalr = 0;
            op1_src = 1;
            op2_src = 1;
            ALU_func = `ADD;
            br_type = 0;
            load_npc = 0;
            wb_select = 0;
            load_type = 0;
            reg_write_en = 1;
            cache_write_en = 0;
            imm_type = `UTYPE;
            CSR_write_en = 0;
            CSR_zimm_or_reg = 0;
        end
        else if (opcode == `J_JALR)
        begin
            jal = 0;
            jalr = 1;
            op1_src = 0;
            op2_src = 1;
            ALU_func = `ADD;
            br_type = 0;
            load_npc = 1;
            wb_select = 0;
            load_type = 0;
            reg_write_en = 1;
            cache_write_en = 0;
            imm_type = `ITYPE;
            CSR_write_en = 0;
            CSR_zimm_or_reg = 0;
        end
        else if (opcode == `B_TYPE)
        begin
            jal = 0;
            jalr = 0;
            op1_src = 0;
            op2_src = 0;
            ALU_func = 0;
            
            load_npc = 0;
            wb_select = 0;
            load_type = 0;
            reg_write_en = 0;
            cache_write_en = 0;
            imm_type = `BTYPE;
            CSR_write_en = 0;
            CSR_zimm_or_reg = 0;
            if (funct3 == `B_BEQ)
            begin
                br_type = `BEQ;
            end
            else if (funct3 == `B_BNE)
            begin
                br_type = `BNE;
            end
            else if (funct3 == `B_BLT)
            begin
                br_type = `BLT;
            end
            else if (funct3 == `B_BGE)
            begin
                br_type = `BGE;
            end
            else if (funct3 == `B_BLTU)
            begin
                br_type = `BLTU;
            end
            else if (funct3 == `B_BGEU)
            begin
                br_type = `BGEU;
            end
            else 
            begin
                br_type = `NOBRANCH;
            end
        end
        else if (opcode == `I_ARI)
        begin
            jal = 0;
            jalr = 0;
            op1_src = 0;
            op2_src = 1;
            
            br_type = 0;
            load_npc = 0;
            wb_select = 0;
            load_type = 0;
            reg_write_en = 1;
            cache_write_en = 0;
            imm_type = `ITYPE;
            CSR_write_en = 0;
            CSR_zimm_or_reg = 0;
            if (funct3 == `I_ADDI)
            begin
                ALU_func = `ADD;
            end
            else if (funct3 == `I_SLTI)
            begin
                ALU_func = `SLT;
            end
            else if (funct3 == `I_SLTIU)
            begin
                ALU_func = `SLTU;
            end
            else if (funct3 == `I_XORI)
            begin
                ALU_func = `XOR;
            end
            else if (funct3 == `I_ORI)
            begin
                ALU_func = `OR;
            end
            else if (funct3 == `I_ANDI)
            begin
                ALU_func = `AND;
            end
            else if (funct3 == `I_SLLI)
            begin
                ALU_func = `SLL;
            end
            else if (funct3 == `I_SR)
            begin
                if (funct7 == `I_SRAI)
                begin
                    ALU_func = `SRA;
                end
                else if (funct7 == `I_SRLI)
                begin
                    ALU_func = `SRL;
                end
            end
            else 
            begin
                ALU_func = 0;
            end
        end
        else if (opcode == `S_TYPE)
        begin
            jal = 0;
            jalr = 0;
            op1_src = 0;
            op2_src = 1;
            ALU_func = `ADD;
            br_type = 0;
            load_npc = 0;
            wb_select = 0;
            load_type = 0;
            reg_write_en = 0;
            cache_write_en = 4'b1111;
            imm_type = `STYPE;
            CSR_write_en = 0;
            CSR_zimm_or_reg = 0;
        end
        else if (opcode == `R_TYPE)
        begin
            jal = 0;
            jalr = 0;
            op1_src = 0;
            op2_src = 0;

            br_type = 0;
            load_npc = 0;
            wb_select = 0;
            load_type = 0;
            reg_write_en = 1;
            cache_write_en = 0;
            imm_type = `RTYPE;
            CSR_write_en = 0;
            CSR_zimm_or_reg = 0;
            if (funct3 == `R_AS)
            begin
                if (funct7 == `R_ADD)
                begin
                    ALU_func = `ADD;
                end
                else if (funct7 == `R_SUB)
                begin
                    ALU_func = `SUB;
                end
            end
            else if (funct3 == `R_SLL)
            begin
                ALU_func = `SLL;
            end
            else if (funct3 == `R_SLT)
            begin
                ALU_func = `SLT;
            end
            else if (funct3 == `R_SLTU)
            begin
                ALU_func = `SLTU;
            end
            else if (funct3 == `R_XOR)
            begin
                ALU_func = `XOR;
            end
            else if (funct3 == `R_SR)
            begin
                if (funct7 == `R_SRL)
                begin
                    ALU_func = `SRL;
                end
                else if (funct7 == `R_SRA)
                begin
                    ALU_func = `SRA;
                end
            end
            else if (funct3 == `R_OR)
            begin
                ALU_func = `OR;
            end
            else if (funct3 == `R_AND)
            begin
                ALU_func = `AND;
            end
            else 
            begin
                ALU_func = 0;
            end
        end
        else if (opcode == `I_CSR)
        begin
            jal = 0;
            jalr = 0;
            op1_src = 0;
            op2_src = 0;
            
            br_type = 0;
            load_npc = 0;
            wb_select = 0;
            load_type = 0;
            reg_write_en = 1;
            cache_write_en = 0;
            imm_type = 0;
            CSR_write_en = 1;
            
            if (funct3 == `I_CSRRC)
            begin
                ALU_func = `NAND;
                CSR_zimm_or_reg = 0;
            end
            else if (funct3 == `I_CSRRCI)
            begin
                ALU_func = `NAND;
                CSR_zimm_or_reg = 1;
            end
            else if (funct3 == `I_CSRRS)
            begin
                ALU_func = `OR;
                CSR_zimm_or_reg = 0;
            end
            else if (funct3 == `I_CSRRSI)
            begin
                ALU_func = `OR;
                CSR_zimm_or_reg = 1;
            end
            else if (funct3 == `I_CSRRW)
            begin
                ALU_func = `OP1;
                CSR_zimm_or_reg = 0;
            end
            else if (funct3 == `I_CSRRWI)
            begin
                ALU_func = `OP1;
                CSR_zimm_or_reg = 1;
            end
            else 
            begin
                ALU_func = 0;
                CSR_zimm_or_reg = 0;
            end
        end
        else 
        begin
            jal = 0;
            jalr = 0;
            op1_src = 0;
            op2_src = 0;
            ALU_func = 0;
            br_type = 0;
            load_npc = 0;
            wb_select = 0;
            load_type = 0;
            reg_write_en = 0;
            cache_write_en = 0;
            imm_type = 0;
            CSR_write_en = 0;
            CSR_zimm_or_reg = 0;
        end
    end

endmodule