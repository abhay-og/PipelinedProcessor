module control_signal(input [5:0] Opcode,output reg [0:0] RegDst,output reg [0:0] Jump,output reg [0:0] Branch, output reg nBranch, output reg [0:0] MemWrite,output reg [0:0] MemtoReg,output reg [1:0] ALUOp,output reg [0:0] ALUSrc,output reg [0:0] RegWrite, output reg Halt);
always @(*)
case (Opcode)
 6'b000000 : begin // R - type
    RegDst = 1'b1; //chooses if the write register is rt or rd
    Jump = 1'b0; //decides whether to jump or not
    Branch = 1'b0; //chooses if beq_branch is taken or not
    nBranch = 1'b0; //chooses if bne_branch is taken or not
    MemtoReg= 1'b0; //chooses b/w read data from data memory and ALU result
    ALUOp = 2'b10; //goes in ALU control
    MemWrite= 1'b0; //Data memory contents replaced by value of Write data input 
    ALUSrc = 1'b0;  //Decides for second ALU operand
    RegWrite= 1'b1; //Write register written with Write data input
    Halt = 1'b0; //Halts the program
end
 6'b100011 : begin // lw - load word
    RegDst = 1'b0;
    Jump = 1'b0;
    Branch = 1'b0;
    nBranch = 1'b0;
    MemtoReg= 1'b1;
    ALUOp = 2'b00;
    MemWrite= 1'b0;
    ALUSrc = 1'b1;
    RegWrite= 1'b1;
    Halt = 1'b0;
    end
 6'b101011 : begin // sw - store word
     RegDst = 1'b0;
     Jump = 1'b0;
     Branch = 1'b0;
     nBranch = 1'b0;
      ALUOp = 2'b00;
      MemtoReg = 1'b0;
      MemWrite= 1'b1;
     ALUSrc = 1'b1;
     RegWrite= 1'b0;
     Halt = 1'b0;
    end
 6'b000100 : begin // beq - branch if equal
     RegDst = 1'b0;
     Jump = 1'b0;
     Branch = 1'b1;
     nBranch = 1'b0;
     MemtoReg= 1'b0;
     ALUOp = 2'b01;
     MemWrite= 1'b0;
     ALUSrc = 1'b0;
     RegWrite= 1'b0;
     Halt = 1'b0;
    end
    
    6'b000101 : begin // bne - branch not equal
     RegDst = 1'b0;
     Jump = 1'b0;
     Branch = 1'b0;
     nBranch = 1'b1;
     MemtoReg= 1'b0;
     ALUOp = 2'b01;
     MemWrite= 1'b0;
     ALUSrc = 1'b0;
     RegWrite= 1'b0;
     Halt = 1'b0;
    end

 6'b001000 : begin // ADI - ADD immidiate
     RegDst = 1'b0;
     ALUSrc = 1'b1;
     MemtoReg= 1'b0;
     RegWrite= 1'b1;
     MemWrite= 1'b0;
     Branch = 1'b0;
     nBranch = 1'b0;
     ALUOp = 2'b11;
     Jump = 1'b0;
     Halt = 1'b0;
    end

 6'b000010 : begin // j - Jump
     RegDst = 1'b0;
     ALUSrc = 1'b0;
     MemtoReg= 1'b0;
     RegWrite= 1'b0;
     MemWrite= 1'b0;
     Branch = 1'b0;
     nBranch = 1'b0;
     ALUOp = 2'b00;
     Jump = 1'b1;
     Halt = 1'b0;
    end
    
6'b111111 : begin// hlt
  RegDst = 1'b0;
     ALUSrc = 1'b0;
     MemtoReg= 1'b0;
     RegWrite= 1'b0;
     MemWrite= 1'b0;
     Branch = 1'b0;
     nBranch = 1'b0;
     ALUOp = 2'b00;
     Jump = 1'b0;
     Halt = 1'b1;
end
 default : begin 
     RegDst = 1'b0;
     ALUSrc = 1'b0;
     MemtoReg= 1'b0;
     RegWrite= 1'b0;
     MemWrite= 1'b0;
     Branch = 1'b0;
     nBranch = 1'b0;
     ALUOp = 2'b10;
     Jump = 1'b0;
     Halt = 1'b0;
    end
endcase
endmodule