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

assign out = psum_q;

// Your code goes here
wire [psum_bw-2:0] multi_mag, psum_mag_q;
wire psum_sign_q, multi_sign, compare;

assign psum_sign_q = psum_q[psum_bw-1];
assign psum_mag_q = psum_q[psum_bw-2:0];
assign compare = psum_mag_q >= multi_mag;
assign multi_mag = a_q[bw-2:0] * b_q[bw-2:0];
assign multi_sign = a_q[bw-1] ^ b_q[bw-1];

always @(posedge clk) begin
  if (reset) begin
    psum_q <= 0; 
    a_q <= 0;
    b_q <= 0;
  end else begin
    a_q <= A;
    b_q <= B;
    if (acc) begin
      if (~format)
        psum_q <= psum_q + a_q * b_q;
      else begin
        case ({compare, multi_sign ^ psum_sign_q})
                2'b00, 2'b10: psum_q <= {multi_sign, psum_mag_q + multi_mag};
                2'b01: psum_q <= {multi_sign , multi_mag - psum_mag_q};
                2'b11: psum_q <= {psum_sign_q, psum_mag_q - multi_mag};
        endcase
      end
    end
  end
end


endmodule
