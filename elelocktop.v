module elelocktop(push, mem, cls, led4, led3, led2, led1, led0, CLK, RST);
    defparam syncro0.WIDTH = 10;
    defparam syncro1.WIDTH = 1;
    defparam syncro2.WIDTH = 1;

    input [9:0]push;
    input mem;
    input cls;
    output [6:0]led4, led3, led2, led1, led0;
    input CLK;
    input RST;

    wire [9:0]push_out;
    wire mem_out;
    wire cls_out;
    wire [4:0]dispen;
    wire [3:0]out4, out3, out2, out1, out0;

    syncro syncro0(.in(push), .out(push_out), .CLK(CLK), .RST(RST));
    syncro syncro1(.in(mem), .out(mem_out), .CLK(CLK), .RST(RST));
    syncro syncro2(.in(cls), .out(cls_out), .CLK(CLK), .RST(RST));

    ledout ledout0(.in(out0), .en(dispen[0]), .out(led0));
    ledout ledout1(.in(out1), .en(dispen[1]), .out(led1));
    ledout ledout2(.in(out2), .en(dispen[2]), .out(led2));
    ledout ledout3(.in(out3), .en(dispen[3]), .out(led3));
    ledout ledout4(.in(out4), .en(dispen[4]), .out(led4));

    elelock elelock(.decimal(push_out), .mem(mem_out), .cls(cls_out), .out4(out4), .out3(out3), .out2(out2), .out1(out1), .out0(out0), .dispen(dispen), .CLK(CLK), .RST(RST));

endmodule
