`timescale 1ps/100fs
`include "register_file.v"
`include "instruction_fetch.v"
`include "instruction_decode.v"
`include "data_memory.v"
`include "control_signal.v"
`include "ALU.v"
`include "write_back.v"
// `include "mux2x1_32.v"
`include "And.v"
`include "PC_add_1.v"
`include "ALU_control.v"
`include "sign_extend.v"
`include "Stall.v"
`include "makeNop.v"
`include "branch_detect.v"
`include "initialize_stall.v"
`include "PC_sub_1.v"

module main2();
wire reset;
reg clk;

//wire for carrying zero bit
reg zero;

//instruction fetch reg and wires, PC1 = PC + 1, PC_next0 after branch comparison and PC_next1 after jump comparison
wire[31 : 0] instruction, PC1, PC_next0, PC_next1, PC_next2, PCn1;
reg[31 : 0] IF_instruction, IF_PC;
reg IF_stall2;
reg[31 : 0] PC;

//all control signals
wire RegDst0, ALUsrc0, MemToReg0, RegWrite0, MemWrite0, Branch0, Jump0, Halt0;
wire RegDst, ALUsrc, MemToReg, RegWrite, MemWrite, Branch, Jump, stall, Halt;
wire[1 : 0] ALUop;

//decoded signals
wire[5 : 0] op, funct;
wire[4 : 0]  rs, rt, rd;
wire[4 :0] rd0, rt0;
wire[15 : 0] imm;
wire[31 : 0] imm32;

//reg and wires before execution
wire[31 : 0] read_data1, read_data2;
wire[3 : 0] operation;
reg[31 : 0] EX_read_data1, EX_read_data2, EX_imm;
reg[5 : 0] EX_funct, EX_op;
reg[4 : 0] EX_rd, EX_rt;
reg EX_RegDst, EX_ALUsrc, EX_MemToReg, EX_RegWrite, EX_MemWrite, EX_Branch, EX_Jump, EX_Halt;
wire stall1;
reg[1 : 0]  EX_ALUop;

//reg and wires before memory acess
wire[31 : 0] result, ALUoperand2;
wire[4 : 0] write_back_address;
wire[2 : 0] flags;
reg[31 : 0] MEM_result,MEM_read_data2;
reg[4 : 0] MEM_rd;
reg MEM_Branch, MEM_Jump, MEM_MemWrite, MEM_MemToReg, MEM_RegWrite, MEM_zero, MEM_Halt;
reg[31 : 0] MEM_imm;

//reg and wires before write back
wire[31 : 0] read_data_mem;
wire Do_branch;
reg[31 : 0] WB_result, WB_read_data_mem;
reg[4 : 0] WB_rd;
reg WB_MemToReg, WB_RegWrite, WB_Halt;

wire[31: 0] write_data;



//instruction fetch
instruction_fetch if1(PC,instruction);
PC_add_1 pa1(PC,PC1);
// initialize_stall is45(PC, Do_branch);
mux2x1_32 mx(PC_next0, PC1, EX_imm, Do_branch);
mux2x1_32 mx3(PC_next1,PC_next0, EX_imm, EX_Jump);
// initialize_stall is1(PC, stall);
PC_sub_1 ps1(PC, PCn1);
mux2x1_32 mx4(PC_next2, PC_next1, PCn1, stall);


//instruction decode
instruction_decode id1(clk, IF_instruction, op, rs, rt, rd, funct, imm);
control_signal cs1(op, RegDst, Jump, Branch, MemWrite, MemToReg, ALUop, ALUsrc, RegWrite, Halt);
Stall st1(rs, rt, RegDst, EX_RegDst, EX_rd, EX_rt, EX_RegWrite, MEM_rd, MEM_RegWrite, WB_rd, WB_RegWrite, IF_stall2, stall);
// initialize_stall is2(PC, stall1);
makeNop mn1(stall, stall1, IF_stall2, RegDst, Jump, Branch, MemWrite, MemToReg, ALUsrc, RegWrite, Halt, rd, rt, RegDst0, Jump0, Branch0, MemWrite0, MemToReg0, ALUsrc0, RegWrite0, Halt0, rd0, rt0);
register_file rf1(clk, reset, rs, rt, rd, WB_rd, WB_RegWrite, write_data, read_data1, read_data2);
sign_extend se1(imm32, imm);

//execution
mux2x1_32 mx0(ALUoperand2, EX_read_data2, EX_imm, EX_ALUsrc);
ALU alu1(clk, reset, EX_read_data1, ALUoperand2, operation, result, flags); 
mux2x1_5 mx1(write_back_address, EX_rt, EX_rd, EX_RegDst);
ALU_control alc1(operation, EX_funct, EX_ALUop);
// And and2(flags[2], EX_Branch, stall1);
branch_detect bd1(EX_Branch, flags[2], EX_op, Do_branch, stall1);


 //memory access 
data_memory dm1(clk, MEM_result, MEM_read_data2, MEM_MemWrite, read_data_mem);


//write back
mux2x1_32 mx2(write_data, WB_result, WB_read_data_mem, WB_MemToReg);
// register_file rf2(clk, reset, rs, rt ,WB_rd, WB_RegWrite, write_data, read_data1, read_data2);

always #100 clk = !clk;

initial begin
    // stall1=1'b0;
    IF_instruction = 32'b11101100000000000000000000000000;
    EX_Halt = 1'b0;
    MEM_Halt = 1'b0;
    WB_Halt = 1'b0;
    IF_PC = 32'b0;
    IF_stall2 = 32'b0;
    EX_read_data1 = 32'b0;
    EX_read_data2 = 32'b0;
    EX_op = 6'b1;
    EX_imm = 32'b0;
    EX_funct = 6'b0;
    EX_rd = 5'b0;
    EX_rt = 5'b0;
    EX_RegDst = 1'b0;
    EX_ALUsrc = 1'b0;
    EX_MemToReg = 1'b0;
    EX_RegWrite = 1'b0;
    EX_MemWrite = 1'b0;
    EX_Branch = 1'b0;
    EX_Jump = 1'b0;
    EX_ALUop = 2'b00;
    MEM_Branch = 1'b0;
    MEM_Jump = 1'b0;
    MEM_imm=32'b0;
    MEM_read_data2 = 32'b0;
    MEM_result = 32'b0;
    MEM_MemWrite = 1'b0;
    MEM_MemToReg = 1'b0;
    MEM_RegWrite = 1'b0;
    MEM_zero = 1'b0;
    MEM_rd = 5'b0;
    WB_result = 32'b0;
    WB_read_data_mem = 32'b0;
    WB_rd = 5'b0;
    WB_MemToReg = 1'b0;
    WB_RegWrite = 1'b0;
    // MEM_zero=1'b0;
    clk = 1'b0;
    PC = 32'b0;
    zero = 1'b0;

end

always @(posedge clk) begin
    


    #3
    $display("%d %d %d %d %d %d",Do_branch,result, EX_Branch, stall1, Halt0, PC);
if(WB_Halt==1'b1) begin
        $finish;
    end

    

    // set clock time accordingly, 10 temporarily
    PC <= PC_next2;
    IF_instruction <= instruction;
    IF_PC <= PC1;
    IF_stall2 <=(stall1||stall);

    //before execution
    EX_read_data1 <= read_data1;
    EX_read_data2 <= read_data2;
    EX_op <= op;
    EX_rd <= rd0;
    EX_rt <= rt0;
    EX_imm <= imm32;
    EX_funct <=funct;
    EX_RegDst <= RegDst0;
    EX_ALUsrc <= ALUsrc0;
    EX_MemToReg <= MemToReg0;
    EX_RegWrite <= RegWrite0;
    EX_MemWrite <= MemWrite0;
    EX_Branch <= Branch0;
    EX_Jump <= Jump0;
    EX_Halt <= Halt0;
    EX_ALUop <= ALUop;

    //before memory access
    MEM_result <= result;
    MEM_read_data2 <= EX_read_data2;
    MEM_rd <= write_back_address;   
    MEM_Branch <= EX_Branch;
    MEM_MemToReg <= EX_MemToReg;
    MEM_MemWrite <= EX_MemWrite;
    MEM_RegWrite <= EX_RegWrite;
    MEM_imm <= EX_imm;
    MEM_zero <= flags[2];
    MEM_Jump <= EX_Jump;
    MEM_Halt <= EX_Halt;

    //before write back
    WB_rd <= MEM_rd;
    WB_read_data_mem <= read_data_mem;
    WB_result <= MEM_result;
    WB_MemToReg <= MEM_MemToReg;
    WB_RegWrite <= MEM_RegWrite;
    WB_Halt <= MEM_Halt;

end

endmodule
