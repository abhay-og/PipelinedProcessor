module ALU(clk,reset,primaryOperand,secondaryOperand,operation,result,flags_zero);
input clk;
input reset;  // Asynchronous reset, active low

input [31:0] primaryOperand ;// Used for all operations except passthrough
input[31:0] secondaryOperand ;// Used for two-operand operations
input[3:0] operation; // upto 16 operations

output[31:0] result;
reg[31:0] result;
output flags_zero;
reg flags_zero; // Zero

/* 
ALU_PASSTHROUGH 4’b1100
ALU_ADD 4’b0001
ALU_SUBTRACT 4’b0010
ALU_MULTIPLY 4’b0011
ALU_AND 4’b0100
ALU_OR 4’b0101
ALU_LOGICAL_SHIFT_RIGHT 4’b0110
ALU_LOGICAL_SHIFT_LEFT 4’b0111
ALU_ARITH_SHIFT_RIGHT 4’b1001
ALU_ARITH_SHIFT_LEFT 4’b1010
ALU_TWOS_COMPLEMENT 4’b1011
ALU_COMPLEMENT 4’b1000
4’b0000 is taken for NOP 4’b1111 for JUMP - these will give a 0 result

ZEROFLAG 2
CARRYFLAG 1
NEGFLAG 0

*/

always @(posedge clk) begin
    result[31:0] = 32'b0; // reset all of the bits so we dont infer any latches
    // do the requested operation
    case(operation)
        4'b1100:  begin // ALU PASSTHROUGH
            result[31:0] = secondaryOperand; // send the data bus input directly to the result
            //its pointless to pass the register operand through. if we need to move it from one register to another, we can just put it on the data bus.
          
        end
        4'b0001: begin // ADD
            result[31:0] = primaryOperand + secondaryOperand;
        end
        4'b0010: begin // Subtract
            result[31:0] = primaryOperand - secondaryOperand;
        end
        4'b0011: begin // Multiply
            result[31:0] = primaryOperand * secondaryOperand;
        end
        4'b0100: begin // AND
            result[31:0] = primaryOperand & secondaryOperand; 
        end
        4'b0101: begin // OR
            result[31:0] = primaryOperand | secondaryOperand; 
        end
        4'b0110: begin // ALU LOGICAL SHIFT RIGHT
            result[31:0] = primaryOperand >> 1; // shift one bit
        end
        4'b0111: begin // ALU LOGICAL SHIFT LEFT
            result[31:0] = primaryOperand << 1; // shift one bit
        end
        4'b1001: begin // ALU ARITH SHIFT RIGHT
            result[31:0] = primaryOperand >>> 1; // one bit shift
        end
        4'b1010: begin //ALU ARITH SHIFT LEFT
            result[31:0] = primaryOperand <<< 1; // one bit shift
        end
        4'b1011: begin // ALU TWOs COMPLEMENT
            result = ~primaryOperand;  // complement
        end
        4'b1000: begin // ALU COMPLEMENT
            result = ~primaryOperand; // complement
        end
        default: begin
            result[31:0] = 32'd0;
        end
    endcase

    if(operation ==  4'b0011) begin // for multiply operation
        flags_zero = (result[31:0] == 32'h0000) ? 1'b1 : 1'b0; // set or unset zero flag
    end
    else begin // for other operations
    
            flags_zero = (result[31:0] == 32'h0000) ? 1'b1 : 1'b0; // set or unset zero flag
        end 
    end // always posedge clock

endmodule