module box (I, O);
  input  wire I;
  output wire O;

  parameter PARAM_STRING  = "A string.";
  parameter PARAM_INTEGER = 10;
  parameter PARAM_REAL    = 3.14;

  assign O = I;

endmodule
