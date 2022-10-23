module branch_detect(input Branch,
                     input Zero,
                     input nBranch,
                     input jump,
                     output Do_branch,
                     output stall);

//detects during execution after result is calculated whether to do branch or jump
//FOR BEQ: Branch is one and zero flag is one
//FOR BNE: nBranch is one and zero is zero

assign Do_branch = (Branch&Zero)|(nBranch&(!Zero));
assign stall = (Branch&Zero)|(nBranch&(!Zero))|(jump);

endmodule