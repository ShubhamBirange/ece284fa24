// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, A, B, format, acc, clk, reset);

parameter bw = 8;
parameter psum_bw = 16;

input clk;
input acc;
input reset;
input format;

input signed [bw-1:0] A;
input signed [bw-1:0] B;

output signed [psum_bw-1:0] out;

reg signed [psum_bw-1:0] psum_q;
reg signed [bw-1:0] a_q;
reg signed [bw-1:0] b_q;

assign out = format ? 
                {psum_q[psum_bw-1], psum_q[psum_bw-1] ? 
                    -psum_q[psum_bw-2:0] : 
                    psum_q[psum_bw-2:0]} : 
                psum_q;

always @(posedge clk) begin
    if (reset) begin
        a_q <= 0;
        b_q <= 0;
        psum_q <= 0;
    end else begin
        a_q <= A;
        b_q <= B;
        
        if (!format)
            psum_q <= psum_q + a_q * b_q;
        else begin
            if ((a_q[bw-1] == b_q[bw-1]))
                psum_q <= psum_q + {2'b0, a_q[bw-2:0] * b_q[bw-2:0]};
            else
                psum_q <= psum_q - {2'b0, a_q[bw-2:0] * b_q[bw-2:0]};
        end
    end
end

endmodule
