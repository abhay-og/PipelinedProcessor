module makeNop(input stall,
               input stall1,
               input stall2,
               input RegDst,
               input Jump,
               input Branch,
               input nBranch,
               input MemWrite,
               input MemToReg,
               input ALUSrc,
               input RegWrite,
               input Halt,
               input[4 : 0] rd,
               input[4 : 0] rt,
               output RegDst0,
               output Jump0,
               output Branch0,
               output nBranch0,
               output MemWrite0,
               output MemToReg0,
               output ALUSrc0,
               output RegWrite0,
               output Halt0,
               output[4 : 0] rd0,
               output[4 : 0] rt0
               );

    //whenever stall is detected make all control signals as zero, so instructions pass through without making changes to memory
    assign RegDst0 = (stall||stall1||stall2)? (1'b0):(RegDst);
    assign Jump0 = (stall||stall1||stall2)? (1'b0):(Jump);
    assign Branch0 = (stall||stall1||stall2)? (1'b0):(Branch);
    assign MemWrite0 = (stall||stall1||stall2)? (1'b0):(MemWrite);
    assign MemToReg0 = (stall||stall1||stall2)? (1'b0):(MemToReg);
    assign ALUSrc0 = (stall||stall1||stall2)? (1'b0):(ALUSrc);
    assign RegWrite0 = (stall||stall1||stall2)? (1'b0):(RegWrite);
    assign Halt0 = (stall||stall1||stall2)? (1'b0): (Halt);
    assign nBranch0 = (stall||stall1||stall2)? (1'b0): (nBranch);
    assign rd0 = (stall||stall1||stall2)? (5'b0):(rd);  //avoid infinity stalling
    assign rt0 = (stall||stall1||stall2)? (5'b0): (rt); //avoid infinity stalling


endmodule