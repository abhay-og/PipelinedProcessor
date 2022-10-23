module register_file(input clk,
                     input reset,
                     input [4 : 0] rs,
                     input [4 : 0] rt,
                     input [4 : 0] rd,
                     input[4 : 0] WB_rd,
                     input write_enable,
                     input[31 : 0] write_data,
                     input stall,
                     input stall1,
                     input IF_stall2,
                     output [31 : 0] read_data1,
                     output [31 : 0] read_data2);
    

    reg[31 : 0] registers[0 : 31];

    //initialize all registers to zero
    initial begin
       for (integer i = 0 ; i < 32; i++ ) begin
          registers[i] = 32'b0;
       end
    end


    always @(posedge clk||reset) begin

      if(reset == 1) begin
        for (integer i = 0 ; i < 32; i++ ) begin
          registers[i] = 32'b0;
        end
      end

      else begin
        if(write_enable) begin // if write_enable is 1 then write back....this is an operation of write back stage
          registers[WB_rd] = write_data;
        end
      end
      #2
      if(write_enable) begin
        for(integer i = 0; i < 8 ; i ++) begin
          $display("$%d : %d", i, registers[i]);
        end
      end

    end

    //read data from rs and rt
    assign read_data1 = registers[rs];
    assign read_data2 = registers[rt];

endmodule