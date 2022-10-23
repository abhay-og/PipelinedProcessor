module write_back(input clk,
                  input mem_to_reg,
                  input[31 : 0] data_from_mem,
                  input[31 : 0] data_from_ALU,
                  output reg[31 : 0] write_to_reg);// value is to be stored in register

    always @(posedge clk) begin
        if(mem_to_reg)
            write_to_reg <= data_from_mem;
        else
            write_to_reg <= data_from_ALU;
    end

endmodule