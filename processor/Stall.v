`include "mux2x1_32.v"
module Stall(input[4 : 0] rs,
             input[4 : 0] rt,
             input RegDst,
             input EX_RegDst,
             input[4 : 0] EX_rd,
             input[4 : 0] EX_rt,
             input EX_RegWrite,
             input[4 : 0] MEM_rd,
             input MEM_RegWrite,
             input[4 : 0] WB_rd,
             input WB_RegWrite,
             input IF_stall2,
             output stall );


    //calculate destination register
    wire[4 : 0] rd1;
    mux2x1_5 mx5(rd1, EX_rt, EX_rd, EX_RegDst);

    //if instruction in ID stage has any read registers matching with destination registers of previous three instruction then stall given that destination register is not $0 and the current instruction is not already under stall
    assign stall = (((((rs==rd1&&EX_RegWrite)||(rs==MEM_rd&&MEM_RegWrite)||(rs==WB_rd&&WB_RegWrite))&&(rs!=0))||((((rt==EX_rd&&EX_RegWrite)||(rt==MEM_rd&&MEM_RegWrite)||(rt==WB_rd&&WB_RegWrite))&&(rt!=0)&&(RegDst))))&&(!IF_stall2));

endmodule