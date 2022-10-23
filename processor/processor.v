`timescale 1ps/100fs
`include "register_file.v"
`include "instruction_fetch.v"
`include "instruction_decode.v"
`include "data_memory.v"
`include "control_signal.v"
`include "ALU.v"
`include "PC_add_1.v"
`include "ALU_control.v"
`include "sign_extend.v"
`include "Stall.v"
`include "makeNop.v"
`include "branch_detect.v"
`include "PC_sub_1.v"

module processor();
wire reset;
reg clk;

//wire for carrying zero bit
reg zero;

//instruction fetch reg and wires, PC1 = PC + 1, PC_next0 after branch comparison and PC_next1 after jump comparison
//NOTE: IF/ID registers are named as IF_reg
wire[31 : 0] instruction, PC1, PC_next0, PC_next1, PC_next2, PCn1;
reg[31 : 0] IF_instruction, IF_PC;
reg IF_stall2;
reg[31 : 0] PC;

//all control signals
wire RegDst0, ALUsrc0, MemToReg0, RegWrite0, MemWrite0, Branch0, nBranch0, Jump0, Halt0;
wire RegDst, ALUsrc, MemToReg, RegWrite, MemWrite, Branch, nBranch, Jump, stall, Halt;
wire[1 : 0] ALUop;

//decoded signals
wire[5 : 0] op, funct;
wire[4 : 0]  rs, rt, rd;
wire[4 :0] rd0, rt0;
wire[15 : 0] imm;
wire[31 : 0] imm32;

//reg and wires before execution
//NOTE: ID/EX registers are named as EX_reg
wire[31 : 0] read_data1, read_data2;
wire[3 : 0] operation;
reg[31 : 0] EX_read_data1, EX_read_data2, EX_imm, EX_PC;
reg[5 : 0] EX_funct;
reg[4 : 0] EX_rd, EX_rt;
reg EX_RegDst, EX_ALUsrc, EX_MemToReg, EX_RegWrite, EX_MemWrite, EX_Branch, EX_nBranch, EX_Jump, EX_Halt;
wire stallbeq, stallbne, stall1 ,nflags;
reg[1 : 0]  EX_ALUop;

//reg and wires before memory access
//NOTE: EX/MEM registers are named as MEM_reg
wire[31 : 0] result, ALUoperand2;
wire[4 : 0] write_back_address;
wire flags_zero;
reg[31 : 0] MEM_result, MEM_read_data2, MEM_PC;
reg[4 : 0] MEM_rd;
reg MEM_Jump, MEM_MemWrite, MEM_MemToReg, MEM_RegWrite, MEM_zero, MEM_Halt;
reg[31 : 0] MEM_imm;

//reg and wires before write back
//NOTE: MEM/WB are named as WB_reg
wire[31 : 0] read_data_mem;
wire Do_branch;
reg[31 : 0] WB_result, WB_read_data_mem, WB_PC;
reg[4 : 0] WB_rd;
reg WB_MemToReg, WB_RegWrite, WB_Halt;
wire[31: 0] write_data;



//instruction fetch
instruction_fetch if1(PC,instruction);                                                             //fetch instrution corresponding to PC value from instruction memory
PC_add_1 pa1(PC,PC1);                                                                              // equivalent to PC + 4
mux2x1_32 mx(PC_next0, PC1, EX_imm, Do_branch);                                                    //select PC value acording to branch
mux2x1_32 mx3(PC_next1,PC_next0, EX_imm, EX_Jump);                                                 //selet PC value according to Jump
PC_sub_1 ps1(PC, PCn1);
mux2x1_32 mx4(PC_next2, PC_next1, PCn1, stall);                                                    // if stall for raw hazard then repeat the PC value


//instruction decode
instruction_decode id1(clk, IF_instruction, op, rs, rt, rd, funct, imm);        
control_signal cs1(op, RegDst, Jump, Branch, nBranch, MemWrite, MemToReg, ALUop, ALUsrc, RegWrite, Halt);
Stall st1(rs, rt, RegDst, EX_RegDst, EX_rd, EX_rt, EX_RegWrite, MEM_rd, MEM_RegWrite, WB_rd, WB_RegWrite, IF_stall2, stall);//check for stall if current instrution has potential for stall
makeNop mn1(stall, stall1, IF_stall2, RegDst, Jump, Branch, nBranch, MemWrite, MemToReg, ALUsrc, RegWrite, Halt, rd, rt, RegDst0, Jump0, Branch0, nBranch0, MemWrite0, MemToReg0, ALUsrc0, RegWrite0, Halt0, rd0, rt0); // if current instruction is to be stalled then make this NOP
register_file rf1(clk, reset, rs, rt, rd, WB_rd, WB_RegWrite, write_data, stall, stall1, IF_stall2, read_data1, read_data2);//register file although is mentioned under decode, but is also used for write back
sign_extend se1(imm32, imm);

//execution
mux2x1_32 mx0(ALUoperand2, EX_read_data2, EX_imm, EX_ALUsrc);                                     //select second operand for ALU from immedaite value and read_data2
ALU_control alc1(operation, EX_funct, EX_ALUop);                                                  //generate peratio signal for ALU
ALU alu1(clk, reset, EX_read_data1, ALUoperand2, operation, result, flags_zero); 
mux2x1_5 mx1(write_back_address, EX_rt, EX_rd, EX_RegDst);                                        //select destination register
branch_detect br1(EX_Branch, flags_zero, EX_nBranch, EX_Jump, Do_branch, stall1);                   //detect from ALU result whetheer branch is taken or not, and decide hther to stall or not next two instruction


 //memory access 
data_memory dm1(clk, MEM_result, MEM_read_data2, MEM_MemWrite, read_data_mem);


//write back
mux2x1_32 mx2(write_data, WB_result, WB_read_data_mem, WB_MemToReg);                                //chooses between data to be written back

//clock cycle is 10
always #5 clk = !clk;

initial begin

    //initializing regiters values

    //IF/ID registers
    IF_instruction = 32'b11101100000000000000000000000000;                                          //setting to default so that all control signals generated are zero
    IF_PC = 32'b0;
    IF_stall2 = 32'b0;

    //ID/EX registers
    EX_read_data1 = 32'b0;
    EX_read_data2 = 32'b0;
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
    EX_nBranch = 1'b0;
    EX_Jump = 1'b0;
    EX_ALUop = 2'b00;
    EX_Halt = 1'b0;

    //EX/MEM registers
    MEM_Jump = 1'b0;
    MEM_imm=32'b0;
    MEM_read_data2 = 32'b0;
    MEM_result = 32'b0;
    MEM_MemWrite = 1'b0;
    MEM_MemToReg = 1'b0;
    MEM_RegWrite = 1'b0;
    MEM_zero = 1'b0;
    MEM_rd = 5'b0;
    MEM_Halt = 1'b0;

    //WB/MEM registers
    WB_result = 32'b0;
    WB_read_data_mem = 32'b0;
    WB_rd = 5'b0;
    WB_MemToReg = 1'b0;
    WB_RegWrite = 1'b0;
    WB_Halt = 1'b0;

    // initializing PC and clk
    clk = 1'b0;
    PC = 32'b0;
    zero = 1'b0;
                                                                    
end

always @(posedge clk) begin
    
    // at every new clock cycle tranfer values to next units
    
    #1
    if(WB_RegWrite)
        $display("current PC value %d",WB_PC); // use if you want to display any value
    if(WB_Halt==1'b1) begin
        $finish;
    end

    PC <= PC_next2;
    IF_instruction <= instruction;
    IF_PC <= PC;
    IF_stall2 <=(stall1||stall);

    //before execution
    EX_PC <= IF_PC;
    EX_read_data1 <= read_data1;
    EX_read_data2 <= read_data2;
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
    EX_nBranch <= nBranch0;
    EX_Jump <= Jump0;
    EX_Halt <= Halt0;
    EX_ALUop <= ALUop;

    //before memory access
    MEM_PC <= EX_PC;
    MEM_result <= result;
    MEM_read_data2 <= EX_read_data2;
    MEM_rd <= write_back_address;   
    MEM_MemToReg <= EX_MemToReg;
    MEM_MemWrite <= EX_MemWrite;
    MEM_RegWrite <= EX_RegWrite;
    MEM_imm <= EX_imm;
    MEM_zero <= flags_zero;
    MEM_Jump <= EX_Jump;
    MEM_Halt <= EX_Halt;

    //before write back
    WB_PC <= MEM_PC;
    WB_rd <= MEM_rd;
    WB_read_data_mem <= read_data_mem;
    WB_result <= MEM_result;
    WB_MemToReg <= MEM_MemToReg;
    WB_RegWrite <= MEM_RegWrite;
    WB_Halt <= MEM_Halt;

end

endmodule
