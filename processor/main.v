`timescale 1ps/100fs
`include "register_file.v"
`include "instruction_memory.v"
`include "data_memory.v"
`include "control_signal.v"
`include "ALU.v"
`include "write_back.v"
`include "mux2x1_32.v"
`include "And.v"
`include "PC_add_1.v"
`include "ALU_control.v"
`include "sign_extend.v"
`include "instruction_decode.v"
`include "instruction_fetch.v"

module main();
wire clk,reset;

//wire for carrying zero bit
wire zero;

//instruction fetch reg and wires, PC1 = PC + 1, PC_next0 after branch comparison and PC_next1 after jump comparison
wire[31 : 0] instruction, PC1, PC_next0, PC_next1;
reg[31 : 0] IF_instruction, IF_PC;
reg[31 : 0] PC;

//all control signals
wire RegDst, ALUsrc, MemToReg, RegWrite, MemWrite, Branch, Jump;
wire[1 : 0] ALUop;

//decoded signals
wire[5 : 0] op, funct;
wire[31 : 0]  rs, rt, rd;
wire[15 : 0] imm, imm32;

//reg and wires before execution
wire[31 : 0] read_data1, read_data2;
wire[5 : 0] operation;
reg[31 : 0] EX_read_data1, EX_read_data2, EX_rd, EX_rt, EX_imm, EX_funct;
reg EX_RegDst, EX_ALUsrc, EX_MemToReg, EX_RegWrite, EX_MemWrite, EX_Branch, EX_Jump;
reg[1 : 0]  EX_ALUop;

//reg and wires before memory acess
wire[31 : 0] result, write_back_address, ALUoperand2;
wire[2 : 0] flags;
reg[31 : 0] MEM_result,MEM_read_data2, MEM_rd;
reg MEM_Branch, MEM_Jump, MEM_MemWrite, MEM_imm, MEM_MemToReg, MEM_RegWrite,MEM_zero;

//reg nd wires before write back
wire[31 : 0] read_data_mem;
wire Do_branch;
reg[31 : 0] WB_result, WB_rd, WB_read_data_mem;
reg WB_MemToReg, WB_RegWrite;

wire[31: 0] write_data;



//instruction fetch
instruction_fetch if1(PC,instruction);
PC_add_1 pa1(PC,PC1);
mux2x1_32 mx(PC_next0, PC1, MEM_imm, Do_branch);
mux2x1_32 mx3(PC_next1,PC_next0, MEM_imm, MEM_Jump);

//instruction decode
instruction_decode id1(IF_instruction, op, rs, rt, rd, funct, imm);
control_signal cs1(op, RegDst, jump, Branch, MemWrite, MemToReg, ALUop, ALUsrc, RegWrite);
register_file rf1(clk, reset, rs, rt, rd, zero, write_data, read_data1, read_data2);
sign_extend se1(imm, imm32);

//execution
mux2x1_32 mx0(ALUoperand2, EX_read_data2, EX_imm, EX_ALUsrc);
ALU alu1(clk, reset, EX_read_data1, ALUoperand2, operation, result, flags); 
mux2x1_5 mx1(write_back_address, EX_rt, EX_rd, EX_RegDst);
ALU_control alc1(EX_ALUop, EX_funct, operation);

 //memory access 
data_memory dm1(clk, MEM_result, MEM_read_data2, MEM_MemWrite, read_data_mem);
And and1(MEM_Branch, MEM_zero, Do_branch);


//write back
mux2x1_32 mx2(write_data, WB_result, WB_read_data_mem, WB_MemToReg);
register_file rf2(clk, reset, rs, rt ,WB_rd, WB_RegWrite, write_data, read_data1, read_data2);

initial begin
    PC = 32'b0;
    zero = 1'b0;
end
always @(posedge clock) begin
    
    // set clock time accordingly, 10 temporarily
    PC <= PC_next1;
    IF_instruction <= instruction;
    IF_PC <= PC1;

    //before execution
    EX_read_data1 <= read_data1;
    EX_read_data2 <= read_data2;
    EX_rd <= rd;
    EX_rt <= rt;
    EX_imm <= imm32;
    EX_funct <=funct;
    EX_RegDst <= RegDst;
    EX_ALUsrc <= ALUSrc;
    EX_MemToReg <= MemToReg;
    EX_RegWrite <= RegWrite;
    EX_MemWrite <= MemWrite;
    EX_Branch <= Branch;
    EX_Jump <= Jump;
    EX_ALUop <= ALUop;

    //before memory access
    MEM_read_data2 <= EX_read_data2;
    MEM_rd <= write_back_address;   
    MEM_result <= result;
    MEM_Branch <= EX_Branch;
    MEM_MemToReg <= EX_MemToReg;
    MEM_MemWrite <= EX_MemWrite;
    MEM_RegWrite <= EX_RegWrite;
    MEM_imm <= EX_imm;
    MEM_zero <= flags[2];
    MEM_Jump <= EX_Jump;

    //before write back
    WB_rd <= MEM_rd;
    WB_read_data_mem <= read_data_mem;
    WB_result <= MEM_result;
    WB_MemToReg <= EX_MemToReg;
    WB_RegWrite <= WB_RegWrite;

end

endmodule