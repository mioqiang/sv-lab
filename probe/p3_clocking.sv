interface cb_if (input logic clk);
  logic valid;
  clocking cb @(posedge clk);
    default input #1step output #1;
    output valid;
  endclocking
endinterface
