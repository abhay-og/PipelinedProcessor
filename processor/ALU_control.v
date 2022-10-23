module ALU_control(operation,F,ALUOp);
output [3:0] operation;
reg [3:0] operation;
input [1:0] ALUOp;
input [5:0] F;
wire [7:0] ALUControl;
assign ALUControl = {ALUOp,F};
always @(ALUControl)
casex(ALUControl)
 8'b11xxxxxx: operation=4'b0001; //ALU_ADDI
 8'b10100000: operation=4'b0001; //ALU_ADD 
 8'b10100010: operation=4'b0010; //ALU_SUBTRACT 
 8'b10011000: operation=4'b0011; //ALU_MULTIPLY 
 8'b10100100: operation=4'b0100; //ALU_AND 
 8'b10100101: operation=4'b0101; //ALU_OR 
 8'b10000010: operation=4'b0110; //ALU_LOGICAL_SHIFT_RIGHT
 8'b10000000: operation=4'b0111; //ALU_LOGICAL_SHIFT_LEFT 
//  8'b10101010: ALUControl=4'b1001; //ALU_ARITH_SHIFT_RIGHT 
//  8'b10101010: ALUControl=4'b1010; //ALU_ARITH_SHIFT_LEFT 
//  8'b10101010: ALUControl=4'b1011; //ALU_TWOS_COMPLEMENT
//  8'b10101010: ALUControl=4'b1000; //ALU_COMPLEMENT
 8'b10101010: operation=4'b0000; //NOP
 8'b00xxxxxx: operation=4'b0001; //JUMP
 8'b01xxxxxx: operation=4'b0010; // branch

 default: operation=4'b0000;
 endcase
endmodule