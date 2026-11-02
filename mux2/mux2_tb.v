`timescale 1ns/1ns
module mux2_tb();
        reg S0,S1,S2;
        wire mux2_out;
        mux2 mux2(.a(S0),
                  .b(S1),
                  .sel(S2),
                  .out(mux2_out));
        initial begin
        S2=0;S1=0;S0=0;
        #20
        S2=0;S1=0;S0=1;
        #20
        S2=0;S1=1;S0=0;
        #20
        S2=0;S1=1;S0=1;
        #20
        S2=1;S1=0;S0=0;
        #20
        S2=1;S1=0;S0=1;
        #20
        S2=1;S1=1;S0=0;
        #20
        S2=1;S1=1;S0=1;
        end
endmodule
