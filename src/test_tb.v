`define SIM 1
`include "system.v"
`include "z80.v"
`include "tv80s.v"
`include "tv80_reg.v"
`include "tv80_mcode.v"
`include "tv80_core.v"
`include "tv80_alu.v"
`include "clkdiv.v"


module test();

  system system( reset_n, clk);
  reg clk=0;
  reg reset_n=0;
  wire [5:0] led;

  always
    #1  clk = ~clk;

  initial begin
    $dumpfile("z80.vcd");
    $dumpvars(0, test);
    #5 reset_n = 1;
    #500 $finish;
  end

endmodule