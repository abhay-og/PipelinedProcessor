module PC_add_1(input[31 : 0] PC,
                output[31 : 0] PC1);
    assign PC1 = PC + 1;

endmodule