module p8;
  logic [1:0] v;
  covergroup cg @(posedge v[0]);
    coverpoint v;
  endgroup
  cg c = new();
endmodule
