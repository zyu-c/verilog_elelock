module syncro(in, out, CLK, RST);
    parameter WIDTH = 1;
    input [WIDTH-1:0] in;
    output [WIDTH-1:0] out;
    input CLK;
    input RST;

    reg [WIDTH-1:0] q0;
    reg [WIDTH-1:0] q1;
    reg [WIDTH-1:0] q2;

    assign out = q1 & ~q2;

    always @(posedge CLK or negedge RST)begin
        if(!RST)begin
            q0 <= 0;
            q1 <= 0;
            q2 <= 0;
        end else begin
            q0 <= ~in;
            q1 <= q0;
            q2 <= q1;
        end
    end
endmodule
