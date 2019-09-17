module box (I, O);
  input  wire I;
  output wire O;

  // Parameters
  parameter PARAM_INTEGER = 10;
  parameter [7:0] PARAM_INTEGER_SIZED = 65535;
  parameter PARAM_STRING  = "A string.";
  parameter PARAM_REAL    = 3.14;

  // Localparams
  localparam LOCALPARAM_INTEGER = 20;
  localparam [7:0] LOCALPARAM_INTEGER_SIZED = 70123;
  localparam LOCALPARAM_STRING  = "Another string";
  localparam LOCALPARAM_REAL    = 6.28;

  assign O = I;

endmodule
