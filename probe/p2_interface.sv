interface bus_if (input logic clk);
  logic       valid;
  logic [7:0] data;
  modport tb  (input clk, output valid, output data);
  modport dut (input clk, input valid, input data);
endinterface
