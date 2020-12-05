`timescale 1ns / 1ns
module testbench;
    reg CLK;
    reg RST;
    
    reg [9:0]push;
    reg mem;
    reg cls;

    elelocktop elelocktop(.push(push), .mem(mem), .cls(cls), .CLK(CLK), .RST(RST));

    always begin
        CLK = 1;
        #50	CLK = 0;
        #50;
	end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars;
        RST = 0;
        push = 10'b1111111111;
        mem <= 1;
        cls <= 1;
        #50 RST = 1;
        #50
        #500 push = 10'b1111101111;     //4
        #500 push = 10'b1111111111;
        #500 push = 10'b1110111111;     //6
        #500 push = 10'b1111111111;
        #500 push = 10'b1111101111;     //4
        #500 push = 10'b1111111111;
        #500 push = 10'b0111111111;     //9
        #500 push = 10'b1111111111;
        #500 mem = 0;                   //memory
        #500 mem = 1;
        #2000
        #500 cls = 0;                   //close
        #500 cls = 1;
        #2000
        #500 push = 10'b1111101111;     //4
        #500 push = 10'b1111111111;
        #500 push = 10'b1110111111;     //6
        #500 push = 10'b1111111111;
        #500 push = 10'b1111101111;     //4
        #500 push = 10'b1111111111;
        #500 push = 10'b0111111111;     //9
        #500 push = 10'b1111111111;
        #(6e4) $finish;
    end
endmodule
