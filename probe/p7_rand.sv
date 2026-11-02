class Pkt;
  rand bit [7:0] addr;
endclass
module p7;
  initial begin
    Pkt p = new();
    void'(p.randomize());
    $display("rand ok addr=%0d", p.addr);
  end
endmodule
