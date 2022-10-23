module initialize_stall(input[31 : 0] PC, inout stall1);

    assign stall1 = (PC==32'b0)? (1'b0):(stall1);

endmodule