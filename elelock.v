`define HALT 0
`define MEMNUMIN 1
`define OPENST 2
`define CLOSE 3
`define SECNUMIN 4
`define MATCHDSP 5

//1.22kHz

module elelock(decimal, mem, cls, out4, out3, out2, out1, out0, dispen, CLK, RST);
    input [9:0]decimal;
    input mem;
    input cls;
    output [3:0]out4, out3, out2, out1, out0;
    output [4:0]dispen;
    input CLK;
    input RST;

    reg [2:0]state;
    reg [12:0]cnt;
    reg lock;

    reg [3:0]key[0:3];
    reg [3:0]secret[0:3];

    reg [3:0]out4, out3, out2, out1, out0;
    reg [4:0]dispen;

    //デバッグ用
    // wire [3:0]key0, key1, key2, key3;
    // assign key0 = key[0];
    // assign key1 = key[1];
    // assign key2 = key[2];
    // assign key3 = key[3];
    // wire [3:0]secret0, secret1, secret2, secret3;
    // assign secret0 = secret[0];
    // assign secret1 = secret[1];
    // assign secret2 = secret[2];
    // assign secret3 = secret[3];

    wire sec4;
    assign sec4 = (cnt > 3999);
    wire halfsec;
    assign halfsec = (cnt > 499);

    wire [3:0]d;
    assign d = dectobin(decimal);
    function [3:0]dectobin;
        input [9:0]in;
        case(in)
            10'b0000000001: dectobin = 0;
            10'b0000000010: dectobin = 1;
            10'b0000000100: dectobin = 2;
            10'b0000001000: dectobin = 3;
            10'b0000010000: dectobin = 4;
            10'b0000100000: dectobin = 5;
            10'b0001000000: dectobin = 6;
            10'b0010000000: dectobin = 7;
            10'b0100000000: dectobin = 8;
            10'b1000000000: dectobin = 9;
        endcase
    endfunction

    wire filled;
    assign filled = (key[3] != 4'hf);

    wire match;
    assign match = ((key[3]==secret[3]) && (key[2]==secret[2]) && (key[1]==secret[1]) && (key[0]==secret[0]));

    wire [4:0]numdisp;
    assign numdisp = {1'b0, (key[3]!=4'hf), (key[2]!=4'hf), (key[1]!=4'hf), (key[0]!=4'hf)};

    always@(posedge CLK or negedge RST)begin
        if(!RST)begin
            state <= `HALT;
            cnt <= 0;
            lock <= 0;
            key[3] <= 4'hf;
            key[2] <= 4'hf;
            key[1] <= 4'hf;
            key[0] <= 4'hf;
            secret[3] <= 4'hf;
            secret[2] <= 4'hf;
            secret[1] <= 4'hf;
            secret[0] <= 4'hf;
            out4 <= 4'h0;
            out3 <= 4'ha;
            out2 <= 4'ha;
            out1 <= 4'ha;
            out0 <= 4'ha;
            dispen <= 5'b01111;
        end else begin
            case(state)
                `HALT: begin
                    out4 <= 4'h0;
                    out3 <= 4'ha;
                    out2 <= 4'ha;
                    out1 <= 4'ha;
                    out0 <= 4'ha;
                    dispen <= 5'b01111;
                    if(decimal)begin
                        cnt <= 0;
                        key[3] <= 4'hf;
                        key[2] <= 4'hf;
                        key[1] <= 4'hf;
                        key[0] <= d;
                        state <= `MEMNUMIN;
                    end
                end

                `MEMNUMIN: begin
                    out4 <= 4'h0;
                    out3 <= key[3];
                    out2 <= key[2];
                    out1 <= key[1];
                    out0 <= key[0];
                    dispen <= numdisp;
                    if(decimal)begin
                        cnt <= 0;
                        key[3] <= key[2];
                        key[2] <= key[1];
                        key[1] <= key[0];
                        key[0] <= d;
                    end else if(filled && mem)begin
                        cnt <= 0;
                        secret[3] <= key[3];
                        secret[2] <= key[2];
                        secret[1] <= key[1];
                        secret[0] <= key[0];
                        state <= `OPENST;
                    end else if(sec4)begin
                        state <= `HALT;
                    end else begin
                        cnt <= cnt + 1;
                    end
                end

                `OPENST: begin
                    out4 <= 4'h0;
                    out3 <= 4'h0;
                    out2 <= 4'hf;
                    out1 <= 4'he;
                    out0 <= 4'hd;
                    dispen <= 5'b01111;
                    if(cls)begin
                        cnt <= 0;
                        lock <= 1;
                        key[3] <= 4'hf;
                        key[2] <= 4'hf;
                        key[1] <= 4'hf;
                        key[0] <= 4'hf;
                        state <= `CLOSE;
                    end
                end

                `CLOSE: begin
                    out4 <= 4'hc;
                    out3 <= 4'hb;
                    out2 <= 4'h0;
                    out1 <= 4'h5;
                    out0 <= 4'he;
                    dispen <= 5'b11111;
                    if(decimal)begin
                        cnt <= 0;
                        state <= `SECNUMIN;
                        key[0] <= d;
                    end
                end

                `SECNUMIN: begin
                    out4 <= 4'h0;
                    out3 <= key[3];
                    out2 <= key[2];
                    out1 <= key[1];
                    out0 <= key[0];
                    dispen <= numdisp;
                    if(decimal)begin
                        cnt <= 0;
                        key[3] <= key[2];
                        key[2] <= key[1];
                        key[1] <= key[0];
                        key[0] <= d;
                    end else if(match)begin
                        lock <= 0;
                        state <= `MATCHDSP;
                    end else if(sec4)begin
                        state <= `CLOSE;
                    end else begin
                        cnt <= cnt + 1;
                    end
                end

                `MATCHDSP: begin
                    out4 <= 4'h0;
                    out3 <= key[3];
                    out2 <= key[2];
                    out1 <= key[1];
                    out0 <= key[0];
                    dispen <= numdisp;
                    cnt <= cnt + 1;
                    if(halfsec)begin
                        state <= `OPENST;
                    end
                end
            endcase
        end
    end
endmodule
