class Stim;
  int n;
  function new(); n = 0; endfunction
  function void send(); n++; endfunction
endclass
module p6;
  initial begin
    Stim s = new();
    s.send();
    $display("class ok n=%0d", s.n);
  end
endmodule
