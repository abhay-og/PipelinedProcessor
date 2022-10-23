# PipelinedProcessor
This project is an implementation of a 5-stage pipelined MIPS based processor. The implementation is based on a 
limited ISA, and the implementation was verified by testbenching the various modules used in the project. 
The 'processor.v' contains code for data path and control path is the main file for verilog 32-Bit microprocessor.
On running 'processor.v' pipelining is getting executed. module instruction_fetch reads 'bin_output.txt' and gives instruction 
corresponding to PC value.
