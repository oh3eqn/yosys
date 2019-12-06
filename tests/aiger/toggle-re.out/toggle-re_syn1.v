/* Generated by Yosys 0.8+498 (git sha1 296ecde6, gcc 7.4.0-1ubuntu1~18.04 -fPIC -Os) */

module \../toggle-re.aig (Q, clk, reset, \!Q , enable);
  wire _00_;
  wire _01_;
  wire _02_;
  wire _03_;
  wire _04_;
  wire _05_;
  wire _06_;
  output \!Q ;
  output Q;
  input clk;
  input enable;
  wire n1_inv;
  wire n4;
  wire n4_inv;
  wire n5;
  wire n5_inv;
  wire n6;
  wire n7;
  input reset;
  \$_DFF_P_  _07_ (
    .C(clk),
    .D(_03_),
    .Q(_04_)
  );
  initial _07_.Q = 1'h0;
  \$_NOT_  _08_ (
    .A(_04_),
    .Y(_00_)
  );
  \$_XOR_  _09_ (
    .A(_02_),
    .B(_04_),
    .Y(_05_)
  );
  \$_AND_  _10_ (
    .A(_06_),
    .B(_05_),
    .Y(_03_)
  );
  assign _01_ = _04_;
  assign Q = _01_;
  assign _06_ = reset;
  assign _02_ = enable;
  assign \!Q  = _00_;
endmodule
