module PC_sub_1(input[31 : 0] PC,
                output[31 : 0] PCn1);
    assign PCn1 = PC - 1;
endmodule